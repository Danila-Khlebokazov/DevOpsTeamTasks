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
      echo "@reboot nohup sudo gitlab-runner --user gitlab-runner --working-directory=/home/gitlab-runner --config=/etc/gitlab-runner/config.toml  run &" | crontab
      nohup sudo gitlab-runner --user gitlab-runner --working-directory=/home/gitlab-runner --config=/etc/gitlab-runner/config.toml  run &
      exit 0
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
echo "Token were not provided. Please provide a token using -t option."
exit 1