#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

# Register GitLab Runner
#sudo gitlab-runner register \
#  --non-interactive \
#  --url "https://gitlab.com/" \
#  --token "$RUNNER_TOKEN" \
#  --executor "shell" \
#  --description "shell-runner"

while getopts ':ht' flag; do
  case "$flag" in
    h)
      echo "[options]"
      echo "-h, --help                show brief help"
      echo "--token                   specify a runner token from GitLab"
      exit 0
      ;;
    t)
      token="${OPTARG}"
      sudo gitlab-runner register --non-interactive --url "https://gitlab.com/" --token "$token" --executor "shell" --description "shell-runner"
      ;;
    *)
      echo "No token is specified, you should specify a --token"
      break
      ;;
  esac
done