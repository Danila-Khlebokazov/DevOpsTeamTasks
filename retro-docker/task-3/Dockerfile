FROM ubuntu:20.04

ARG GITLAB_KEY
ARG GITLAB_GROUP

ENV GITLAB_SOURCE="https://gitlab.com"
ENV PROJECT_GROUP="${GITLAB_GROUP}"
ENV GITLAB_ACCESS_TOKEN="${GITLAB_KEY}"
ENV TZ="Asia/Almaty"

RUN apt-get update && apt-get install -y sudo jq git docker.io curl wget unzip

RUN curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

WORKDIR /install

COPY install_gitlab_runner.sh install_gitlab_runner.sh

RUN chmod +x install_gitlab_runner.sh

RUN bash install_gitlab_runner.sh

# Allow passwordless sudo for the user
RUN echo 'myuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

COPY register_gitlab_runner.sh register_gitlab_runner.sh

RUN chmod +x register_gitlab_runner.sh

COPY handler_entrypoint.sh handler_entrypoint.sh

RUN chmod +x handler_entrypoint.sh

ENTRYPOINT ["./handler_entrypoint.sh"]