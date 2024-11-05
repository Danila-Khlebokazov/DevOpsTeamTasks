#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

link=$GITLAB_SOURCE
access_token=$GITLAB_ACCESS_TOKEN
project_group=$PROJECT_GROUP

echo "Link: $link"
echo "Access Token: $access_token"
echo "Project Group: $project_group"

if [ -n "$access_token" ]; then
  if [ -n "$project_group" ]; then
      response=$(curl -X"POST" --header "PRIVATE-TOKEN: $access_token" --data "runner_type=group_type&group_id=$project_group" "$link/api/v4/user/runners")
      echo "Response: $response"
      token=$(echo "$response" | jq -r .token)
      echo "Token: $token"
      sudo gitlab-runner register --non-interactive --url "$link" --token "$token" --executor "docker" --docker-image "ruby:3.3" --name "docker-runner" --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" --docker-privileged
exit 0
  else
    echo "Project group were not provided. Please provide a project group using -g option."
    exit 1
  fi
fi

echo "Token were not provided. Please provide an access token using -t option."
exit 1