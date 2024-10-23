#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

link=$GITLAB_SOURCE
token=$RUNNER_TOKEN

echo "Link: $link"

if [ -n "$token" ]; then
    sudo gitlab-runner register --non-interactive --url "$link" --token "$token" --executor "shell" --description "shell-runner"

    cat << EOF | sudo tee /home/gitlab-runner/.bash_logout
# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

#if [ "$SHLVL" = 1 ]; then
#    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
# fi
EOF
exit 0
fi

echo "Token were not provided."
exit 1