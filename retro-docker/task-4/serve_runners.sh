#! /bin/bash
RUNNER_IMAGE=$DEFAULT_RUNNER_IMAGE

get_current_projects_ids() {
  projects=($(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "https://gitlab.com/api/v4/groups/$GITLAB_GROUP/projects/" | jq '.[].id'))
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
    pending_jobs_all+=$pending_jobs_num
  done
}

get_running_jobs() {
  running_jobs_all=0
  for project_id in "${projects[@]}"; do
    running_jobs_num=$(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$project_id/jobs?scope=running" | jq length);
    running_jobs_all+=$running_jobs_num
  done
}

run_new_runner() {
  docker run -d --name gitlab-runner-$current_runners -e PROJECT_GROUP=$PROJECT_GROUP -e GITLAB_ACCESS_TOKEN=$GITLAB_ACCESS_TOKEN $RUNNER_IMAGE
}

stop_runner() {
  docker container stop $(docker container ls --filter=ancestor=$RUNNER_IMAGE --format "{{.ID}}" | tail -n 1)
}

get_current_projects_ids
get_current_active_runners
get_pending_jobs
get_running_jobs

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
    fi
  done
elif [ $(($running_jobs_all - $current_runners)) -lt 0 ]; then
  for i in $(seq 1 $(($current_runners - $running_jobs_all))); do
    if [ $current_runners -gt $MIN_RUNNERS ]; then
      stop_runner
    fi
  done
fi
