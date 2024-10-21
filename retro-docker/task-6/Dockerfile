FROM python:3.9-slim

# Установим git и необходимые зависимости
RUN apt-get update && apt-get install -y git

# Склонируем репозиторий
RUN git clone https://gitlab.com/lecture-tasks/intro-devops/aiohttp-simple-server

# Устанавливаем aiohttp через pip
RUN pip install aiohttp

# Устанавливаем рабочую директорию
WORKDIR /aiohttp-simple-server

# Запустим приложение
CMD ["python3", "app/main.py"]
