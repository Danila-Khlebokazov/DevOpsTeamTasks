#! /bin/bash
# Stop the gitlab runner
sudo gitlab-runner stop

# Unregister the gitlab runner
sudo gitlab-runner unregister --all-runners

# Remove the gitlab runner
sudo gitlab-runner uninstall

sudo rm -r /etc/gitlab-runner

sudo userdel -r gitlab-runner

sudo rm -r /home/gitlab-runner

echo "" | crontab