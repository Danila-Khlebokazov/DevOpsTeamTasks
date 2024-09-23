#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

while getopts 't:h:' flag; do
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
      sudo touch /etc/systemd/system/gitlab-runner-active.service
      sudo cat > /etc/systemd/system/gitlab-runner-active.service << EOF
[Unit]
Description=GitLab Runner
After=gitlab-runner.service

[Service]
ExecStart=/usr/local/bin/gitlab-runner run
WorkingDirectory=/home/gitlab-runner
Restart=always
User=gitlab-runner

[Install]
WantedBy=multi-user.target
EOF
      sudo systemctl start gitlab-runner-active
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