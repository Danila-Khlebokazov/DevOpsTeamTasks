#! /bin/bash
#Write a script cleanup.sh to clean up the gitlab runner by stopping, unregistering, and removing it from the server when needed.

# Stop the gitlab runner
sudo gitlab-runner stop

# Unregister the gitlab runner
sudo gitlab-runner unregister --all-runners

# Remove the gitlab runner
sudo gitlab-runner uninstall

sudo systemctl disable gitlab-runner