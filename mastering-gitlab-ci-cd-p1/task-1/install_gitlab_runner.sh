#! /bin/bash

# reference https://docs.gitlab.com/runner/install/linux-manually.html

# Check if exists
if [ -x "$(command -v gitlab-runner)" ]; then
  echo 'gitlab-runner is already installed.'
else
  # Get Architecture
  arch=$(uname -m)

  # Linux x86-64
  if [ "$arch" == "x86_64" ]; then
    arch="amd64"
  # Linux x86
  elif [ "$arch" == "i686" ]; then
    arch="386"
  # Linux arm
  elif [ "$arch" == "armv7l" ]; then
    arch="arm"
  # Linux arm64
  elif [ "$arch" == "aarch64" ]; then
    arch="arm64"
  fi
  # Linux s390x - same
  # Linux ppc64le - same

  # Install GitLab Runner
  sudo curl -L --output /usr/local/bin/gitlab-runner "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-$arch"

  # Set execute permissions
  sudo chmod +x /usr/local/bin/gitlab-runner
fi

# Create a CI user if not exists
if id "gitlab-runner" &>/dev/null; then
  echo "User gitlab-runner exists."
else
  sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
fi

# Install Service if not installed
if [ -f /lib/systemd/system/gitlab-runner.service ]; then
  echo "Service gitlab-runner exists."
else
  # Install Service
  sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
fi

# Starting with boot
sudo systemctl enable gitlab-runner
# Running service
sudo gitlab-runner start

