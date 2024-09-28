#! /bin/bash

link="https://gitlab.com"

access_token=$1

if [ -z "$access_token" ]; then
  echo "Please provide the access token"
  echo "Example:"
  echo "$0 <access_token>"
  exit 1
fi

if [ -z "$2" ]; then
  link="$2"
fi

# Stop the gitlab runner
sudo gitlab-runner stop

# Unregister the gitlab runner
sudo gitlab-runner unregister --all-runners

sudo cat /etc/gitlab-runner/config.toml | grep -oP 'id = \K\d+' | xargs -I runner_id curl -X"DELETE" --header "PRIVATE-TOKEN: $access_token" "$link/api/v4/runners/runner_id"

# Remove the gitlab runner
sudo gitlab-runner uninstall

sudo rm -r /etc/gitlab-runner

sudo userdel -r gitlab-runner