#!/bin/bash

# Register Runner
bash register_gitlab_runner.sh

#Execute a command
gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner &

#Wait
wait $!