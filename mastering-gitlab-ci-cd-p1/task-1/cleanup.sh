#! /bin/bash

link="https://gitlab.com"

access_token=$1

if [ -z "$access_token" ]; then
  echo "Please provide the access token"
  echo "Example:"
  echo "$0 <access_token> <action_flags>"
  exit 1
fi

actions=$2

if [ -z "$actions" ]; then
  echo "Please specify actions. Use 1 to stop, 2 to unregister, and 4 to uninstall."
  echo "Example: $0 <access_token> 3 (will stop and unregister)"
  exit 1
fi

if [ -n "$3" ]; then
  link="$3"
fi

stop_runner() {
  echo "Stopping GitLab Runner..."
  sudo gitlab-runner stop || { echo "Failed to stop GitLab Runner"; exit 1; }
}

unregister_runner() {
  echo "Unregistering GitLab Runner..."
  runner_ids=$(sudo cat /etc/gitlab-runner/config.toml | grep -oP 'id = \K\d+')

  sudo gitlab-runner unregister --all-runners || { echo "Failed to unregister runners"; exit 1; }

  # Remove runner from GitLab API
  if [ -n "$runner_ids" ]; then
    echo $runner_ids | xargs -I runner_id curl --request DELETE --header "PRIVATE-TOKEN: $access_token" "$link/api/v4/runners/runner_id"
    echo "Runner(s) unregistered from GitLab."
  else
    echo "No runners found to unregister."
  fi
}

uninstall_runner() {
  echo "Uninstalling GitLab Runner..."
  sudo gitlab-runner uninstall || { echo "Failed to uninstall GitLab Runner"; exit 1; }
  sudo rm -r /etc/gitlab-runner || { echo "Failed to remove /etc/gitlab-runner directory"; exit 1; }
  echo "GitLab Runner uninstalled successfully."
}

# Check actions and execute accordingly
if (( actions & 1 )); then
  stop_runner
fi

if (( actions & 2 )); then
  unregister_runner
fi

if (( actions & 4 )); then
  uninstall_runner
fi

echo "Actions completed."