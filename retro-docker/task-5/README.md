## The project
https://gitlab.com/devopsteamtask/retro-docker-5


## How to test
Pull image from docker hub
```bash
docker pull anuarkurmanov/multi-platform-image:latest
```
Run the image
```bash
docker run -p 8080:8080 anuarkurmanov/multi-platform-image:latest
```
Open the browser and navigate to `http://localhost:8080` to see the response from the server.

**Note:** ensure that the port `8080` is not in use.

**References:** https://docs.docker.com/build/building/multi-platform/

## Task Description

Set up Gitlab CI/CD pipeline that builds docker images for multiple platforms, such
as windows/amd64, linux/amd64, linux/arm64.
Create a reusable CI template that automates the process of building and pushing
docker images. The template should be easily adaptable for various projects and be
configured for different platforms (e.g., Linux/amd64, ARM architectures).
The goal is to create a modular and reusable pipeline configuration that can be
applied across multiple repositories or projects.
Note: pipeline that builds docker images for multiple platforms or selected
platforms