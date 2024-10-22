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

run_new_runner() {
  docker run -d --name gitlab-runner-$current_runners $RUNNER_IMAGE
}

stop_runner() {
  docker container stop $(docker container ls --filter=ancestor=$RUNNER_IMAGE --format "{{.ID}}" | tail -n 1)
}

get_current_projects_ids
get_current_active_runners
get_pending_jobs

if [ $pending_jobs_all -gt 0 ]; then
  if [ $current_runners -lt $MAX_RUNNERS ]; then
    run_new_runner
  fi
elif [ $current_runners -gt $MIN_RUNNERS ]; then
  stop_runner
elif [ $current_runners -lt $MIN_RUNNERS ]; then
  run_new_runner
fi
