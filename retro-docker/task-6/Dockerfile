#build stage use slim image instead of alpine to easly install git
FROM python:3.7-slim as build
# install git and clone the repo
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && git clone https://gitlab.com/lecture-tasks/intro-devops/aiohttp-simple-server \
    && apt-get remove -y git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# use alpine because lightest which i can find
FROM python:3.7-alpine as production
# copy only necessary files
COPY --from=build /aiohttp-simple-server/app/main.py .
# installing aiohttp with specific version
RUN pip install --no-cache-dir aiohttp==3.8

CMD ["python3", "./main.py"]
