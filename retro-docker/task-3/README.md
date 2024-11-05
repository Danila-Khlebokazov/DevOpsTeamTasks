### How to use

1. Pull the docker image from Docker Hub
```bash
docker pull danilakhlebokazov/gitlab-runner:docker-v1.2.0
```

2. Prepare your GitLab access token and Group ID in Gitlab
Also you can specify source url
```bash
GITLAB_SOURCE=https://gitlab.com` # without slash at the end
GITLAB_ACCESS_TOKEN=your_access_token
PROJECT_GROUP=your_group_id
```

3. Run the docker container
```bash
docker run --rm -d --name gitlab-runner \
    -e GITLAB_SOURCE=$GITLAB_SOURCE \
    -e GITLAB_ACCESS_TOKEN=$GITLAB_ACCESS_TOKEN \
    -e PROJECT_GROUP=$PROJECT_GROUP \
    danilakhlebokazov/gitlab-runner:docker-v1.2.0
```

> If you want to see other images you can visit [Docker Hub](https://hub.docker.com/r/danilakhlebokazov/gitlab-runner/tags)
