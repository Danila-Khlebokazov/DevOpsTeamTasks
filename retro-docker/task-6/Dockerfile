FROM python:3.9-slim

RUN apt-get update && apt-get install -y git

RUN git clone https://gitlab.com/lecture-tasks/intro-devops/aiohttp-simple-server

RUN pip install aiohttp

WORKDIR /aiohttp-simple-server

CMD ["python3", "app/main.py"]
