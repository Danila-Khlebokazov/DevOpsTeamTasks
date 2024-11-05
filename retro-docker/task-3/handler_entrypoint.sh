#!/bin/bash

# Register Runner
bash register_gitlab_runner.sh


#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    runner_ids=$(sudo cat /etc/gitlab-runner/config.toml | grep -oP 'id = \K\d+')
    sudo gitlab-runner unregister --all-runners
    if [ -n "$runner_ids" ]; then
    echo $runner_ids | xargs -I runner_id curl --request DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$GITLAB_SOURCE/api/v4/runners/runner_id"
    echo "Runner(s) unregistered from GitLab."
  else
    echo "No runners found to unregister."
  fi
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

#Execute a command
gitlab-runner run &

#Wait
wait $!