# Retro-Docker

### Task 1 Browser in docker

Create a Docker container that runs an old version of a web browser (For example, Internet Explorer 5). The browser
should automatically open website with indi games when the container starts.

### Task 2 V V Viper

Create a script that automatically cleans up Docker images that have not been used for some time. The script should
identify unused images, remove them, and log the cleanup activity, including image Ids and the timestamp of when they
were removed.

Set up script to run periodically using systemd timer. Send a notification (e-mail or telegram) with the log of removed
images after each cleanup.

Important: Make sure to carefully filter the images based on the last used time to avoid removing images that are still
relevant

### Task 3 Containerized GitLab CI Runner

Set up a GitLab CI runner in a Docker container. The runner should be able to execute pipeline jobs, such as building
Docker images or running tests inside containers.

- Install and configure a GitLab CI runner in a Docker container
- Register the runner with your GitLab instance
- Create a CI pipeline that builds a Docker image or runs a test suite in a
  container

### Task 4 Monitor Runners and Scale Based on Pending Jobs

Implement custom monitoring and scaling solution using a systemd service that checks the number of pending pipeline jobs
and adjusts the number of runners accordingly.

### Task 5 Prepare CI to build docker images for multiple platforms

Set up Gitlab CI/CD pipeline that builds docker images for multiple platforms, such as windows/amd64, linux/amd64,
linux/arm64.

Create a reusable CI template that automates the process of building and pushing docker images. The template should be
easily adaptable for various projects and be configured for different platforms (e.g., Linux/amd64, ARM architectures).

The goal is to create a modular and reusable pipeline configuration that can be applied across multiple repositories or
projects.

Note: pipeline that builds docker images for multiple platforms or selected platforms

### Task 6 Dockerfile - best practices

Create docker image strictly following best practices for writing Dockerfiles. Source code that should be
used - https://gitlab.com/lecture-tasks/intro-devops/aiohttp- simple-server/
You are not allowed to download the source code from the GitLab repository in advance. Your Dockerfile must handle
downloading the required source code during the build process.
Functional requirements

- Minimal / optimal base image
- Version / tag of base image ( don’t use latest )
- Multi-stage to reduce the final image size
- Efficient caching and layer management
- No unnecessary installations or files in the final image
- No big files
- Reduce docker context
- CMD / ENTRYPOINT correctly chosen
