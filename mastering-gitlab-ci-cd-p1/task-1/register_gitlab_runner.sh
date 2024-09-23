#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

while getopts t:h: flag; do
  case "$flag" in
    h)
      echo "[options]"
      echo "-h, --help                show brief help"
      echo "-t                        specify a runner token from GitLab"
      exit 0
      ;;
    t)
      token="${OPTARG}"
      sudo gitlab-runner register --non-interactive --url "https://gitlab.com/" --token "$token" --executor "shell" --description "shell-runner"
      echo "@reboot sudo runuser -l gitlab-runner -c 'nohup gitlab-runner run &'" | crontab
      sudo runuser -l gitlab-runner -c 'nohup gitlab-runner run &'
      ;;
    \?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
		;;
		:)
			echo "Option -$OPTARG requires an argument (getopts)" >&2
			exit 1
		;;
  esac
done