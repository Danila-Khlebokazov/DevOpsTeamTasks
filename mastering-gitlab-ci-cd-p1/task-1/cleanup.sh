#! /bin/bash

access_token=$1

if [ -z "$access_token" ]; then
  echo "Please provide the access token"
  echo "Example:"
  echo "$0 <access_token>"
  exit 1
fi

# Stop the gitlab runner
sudo gitlab-runner stop

# Unregister the gitlab runner
sudo gitlab-runner unregister --all-runners

curl --header "PRIVATE-TOKEN: $access_token" "https://gitlab.com/api/v4/runners/all?scope=offline&per_page=100" | jq '.[].id' | xargs -I runner_id curl --request DELETE --header "PRIVATE-TOKEN: $access_token" "https://gitlab.com/api/v4/runners/runner_id"

# Remove the gitlab runner
sudo gitlab-runner uninstall

sudo rm -r /etc/gitlab-runner

sudo userdel -r gitlab-runner