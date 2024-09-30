#! /bin/bash

link="https://gitlab.com"

access_token=$1

if [ -z "$access_token" ]; then
  echo "Please provide the access token"
  echo "Example:"
  echo "$0 <access_token>"
  exit 1
fi

if [ -n "$2" ]; then
  link="$2"
fi

# Stop the gitlab runner
sudo gitlab-runner stop

# Unregister the gitlab runner
runner_ids=$(sudo cat /etc/gitlab-runner/config.toml | grep -oP 'id = \K\d+')

sudo gitlab-runner unregister --all-runners
echo $runner_ids | xargs -I runnder_id curl --request DELETE --header "PRIVATE-TOKEN: $access_token" "$link/api/v4/runners/runnder_id"

# Remove the gitlab runner
sudo gitlab-runner uninstall

sudo rm -r /etc/gitlab-runner

sudo userdel -r gitlab-runner