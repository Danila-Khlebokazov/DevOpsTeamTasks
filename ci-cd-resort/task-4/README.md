## How to use?

1. Firstly you need to install the nexus
```bash
./install-nexus
```

2. Then you go to 127.0.0.1:8081 and log in as admin
(password in `/opt/sonatype-work/nexus3/admin.password`)

3. Then creating the docker repository on http:8083 and !important in Realms activate Docker Bearer Token

4. Then you need to login a docker with nexus user
```bash
docker login 127.0.0.1:8083
Username: admin
Password:
WARNING! Your password will be stored unencrypted in /home/dk/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credential-stores

Login Succeeded
```

5. Then you can push the image to nexus
```bash
docker tag example-image 127.0.0.1:8083/example-image
docker push 127.0.0.1:8083/example-image
```


### Examples

Example of ci integration
```yaml
stages:
  - build
  - deploy


variables:
  IMAGE: $NEXUS_SERVER/$CI_PROJECT_NAME:$CI_COMMIT_SHORT_SHA
  DOCKER_DAEMON_OPTIONS: "--insecure-registry=${NEXUS_SERVER}"

build:
  stage: build
  image: docker:latest
  services:
    - name: docker:20.10.17-dind
      entrypoint: [ "sh", "-c", "dockerd-entrypoint.sh $DOCKER_DAEMON_OPTIONS" ]
  script:
    - docker login -u $NEXUS_LOGIN -p $NEXUS_PASS $NEXUS_SERVER
    - docker build . -t $IMAGE
    - docker push $IMAGE

deploy:
  stage: deploy
  before_script:
    - 'command -v ssh-agent >/dev/null || ( apk add --update openssh )'
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $VM_IPADDRESS >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$VM_IPADDRESS  <<EOF
    - docker pull $IMAGE
    - docker run -d --name $CI_PROJECT_NAME -p 8000:8000 $IMAGE
    - EOF
  only:
    - main
    - /^release-.*$/
  environment:
    name: production
    url: http://$VM_IPADDRESS:8000
```