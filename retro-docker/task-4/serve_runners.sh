#! /bin/bash

echo "Starting GitLab Runner Service at $(date)"
RUNNER_IMAGE=$DEFAULT_RUNNER_IMAGE

get_current_projects_ids() {
  projects=($(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "https://gitlab.com/api/v4/groups/$PROJECT_GROUP/projects/" | jq '.[].id'))
  echo "Projects: " "${projects[@]}"
  export projects
}

get_current_active_runners() {
  current_runners=$(docker container ls --filter=ancestor=$RUNNER_IMAGE --format "{{.ID}}" | wc -l)
  export current_runners
}

get_pending_jobs() {
  pending_jobs_all=0
  for project_id in "${projects[@]}"; do
    pending_jobs_num=$(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$project_id/jobs?scope=pending" | jq length);
    echo "Pending Jobs: $pending_jobs_num"
    pending_jobs_all+=$pending_jobs_num
  done
}

get_running_jobs() {
  running_jobs_all=0
  for project_id in "${projects[@]}"; do
    running_jobs_num=$(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$project_id/jobs?scope=running" | jq length);
    echo "Running Jobs: $running_jobs_num"
    running_jobs_all+=$running_jobs_num
  done
}

run_new_runner() {
  docker run --rm -d --name gitlab-runner-$current_runners -e PROJECT_GROUP=$PROJECT_GROUP -e GITLAB_ACCESS_TOKEN=$GITLAB_ACCESS_TOKEN $RUNNER_IMAGE
}

stop_runner() {
  docker container stop $(docker container ls --filter=ancestor=$RUNNER_IMAGE --format "{{.ID}}" | head -n 1)
}

get_current_projects_ids
get_current_active_runners
get_pending_jobs
get_running_jobs
echo "Current Runners: $current_runners"
echo "Pending Jobs: $pending_jobs_all"
echo "Running Jobs: $running_jobs_all"

# Init runners
if [ $current_runners -eq 0 ]; then
  for i in $(seq 1 $(($MIN_RUNNERS))); do
    run_new_runner
  done
fi

if [ $pending_jobs_all -gt 0 ]; then
  for i in $(seq 1 $pending_jobs_all); do
    if [ $current_runners -lt $MAX_RUNNERS ]; then
      run_new_runner
      echo "New runner started"
      current_runners=$current_runners+1
    fi
  done
elif [ $(($running_jobs_all - $current_runners)) -lt 0 ]; then
  for i in $(seq 1 $(($current_runners - $running_jobs_all))); do
    if [ $current_runners -gt $MIN_RUNNERS ]; then
      stop_runner
      echo "Runner stopped"
      current_runners=$current_runners-1
    fi
  done
fi

echo "GitLab Runner Service finished at $(date)"
