#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

# Register GitLab Runner
#sudo gitlab-runner register \
#  --non-interactive \
#  --url "https://gitlab.com/" \
#  --token "$RUNNER_TOKEN" \
#  --executor "shell" \
#  --description "shell-runner"

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - attempt to capture frames"
      echo " "
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "--token                   specify a runner token from GitLab"
      exit 0
      ;;
    --token)
      token=`echo $1 | sed -e 's/^[^=]*=//g'`
      sudo gitlab-runner register \
        --non-interactive \
        --url "https://gitlab.com/" \
        --token "$token" \
        --executor "shell" \
        --description "shell-runner"
      ;;
    *)
      echo "No token is specified, you should specify a --token"
      break
      ;;
  esac
done