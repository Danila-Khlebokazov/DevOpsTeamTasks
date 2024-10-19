#! /bin/bash

# reference https://docs.gitlab.com/runner/install/linux-manually.html

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

sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
