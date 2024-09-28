#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

link="https://gitlab.com/"

while getopts t:g:h:l: flag; do
  case "$flag" in
    h)
      echo "[options]"
      echo "-h, --help                show brief help"
      echo "-t                        specify an access token from GitLab"
      echo "-g                        specify a group id from GitLab"
      echo "-l                        specify a GitLab link"
      exit 0
      ;;
    t | g)
      if "$flag" == "t"; then
        access_token="${OPTARG}"
      elif "$flag" == "g"; then
        project_group="${OPTARG}"
      fi
      ;;
    l)
      link="${OPTARG}"
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

if [ -n "$access_token" ]; then
  if [ -n "$project_group" ]; then
      token=$(curl --request POST --header "PRIVATE-TOKEN: $access_token" --data "runner_type=group_type&group_id=$project_group" "https://gitlab.com/api/v4/user/runners")
      sudo gitlab-runner register --non-interactive --url "$link" --token "$token" --executor "shell" --description "shell-runner"
      sudo gitlab-runner verify

      cat << EOF | sudo tee /home/gitlab-runner/.bash_logout
# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

#if [ "$SHLVL" = 1 ]; then
#    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
# fi
EOF
exit 0
  else
    echo "Project group were not provided. Please provide a project group using -g option."
    exit 1
  fi
fi

echo "Token were not provided. Please provide an access token using -t option."
exit 1