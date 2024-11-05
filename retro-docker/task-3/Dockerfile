FROM docker:27.3.1-dind-alpine3.20

ENV GITLAB_SOURCE="https://gitlab.com"
ENV PROJECT_GROUP=""
ENV GITLAB_ACCESS_TOKEN=""
ENV TZ="Asia/Almaty"

RUN apk update && apk add --update alpine-sdk sudo jq git curl wget unzip bash

WORKDIR /install

COPY install_gitlab_runner.sh install_gitlab_runner.sh

RUN chmod +x install_gitlab_runner.sh

RUN bash install_gitlab_runner.sh

COPY register_gitlab_runner.sh register_gitlab_runner.sh

RUN chmod +x register_gitlab_runner.sh

COPY handler_entrypoint.sh handler_entrypoint.sh

RUN chmod +x handler_entrypoint.sh

ENTRYPOINT ["./handler_entrypoint.sh"]