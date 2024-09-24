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
      sudo gitlab-runner verify

      cat << EOF | sudo tee /home/gitlab-runner/.bash_logout
# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

#if [ "$SHLVL" = 1 ]; then
#    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
# fi
EOF
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