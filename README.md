# Container based website deployment - kunsol group

## Introduction

As per request of Kunsol group, this report describes the process and the finished tasks for the konsul website. A comprehensive list of all the tools ranging from collaboration platform and monitoring tools, to orchestration and containerisation tools is provided. The following procedure section explains the the reasoning and thought process behind  the many design choices that were made and it is also displays the configurations and the diagrams sections.

## Tools and services used:
1. Rancher:stable container.
2. Azure pipelines.
3. Git / github.
4. Gridsome: A Vue.js framework.
5. Nextcloud.
6. statping:v0.90.36 docker image.
7. buttercup: Passwords management.

## Gridsome Deployment Testing - Done

![console](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/gridsome)

To access the website visit http://40.87.87.148:8080/

## Gridsome CI/CD - Automated Gridsome deployment with Docker and Git

Manually setting the infartructure, deploying the website, tracking code changes and testing them is tiresome and leads to many conflicts and is the total opposite to what DevOps stands for. This can be avoided by automating the process using a container based approach. With containarization, we can setup our infrastructure as many times as we want in a negligeble time, while ensuring the same result everytime.

### Gridsome build with Docker
 __Goal:__ Build an image named gridsome-docker that contains all the necessary dependancies to run our website. 

#### Image Dockerfile 

```
FROM node:14.2.0-alpine3.10

RUN apk update && apk upgrade
RUN apk --no-cache add git g++ gcc libgcc libstdc++ linux-headers make python util-linux

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
USER node
RUN npm i --global gridsome
RUN npm i --global serve

COPY --chown=node:node htu-devops-konsul-web/ /home/node/build/
RUN echo && ls /home/node/build/ && echo
WORKDIR /home/node/build
USER node
RUN npm cache clean --force
RUN npm clean-install
EXPOSE 8080
CMD ~/.npm-global/bin/gridsome build && echo && ls ~/.npm-global/bin/ && ls && ~/.npm-global/bin/serve -d dist/

```
To build the image use the command:
```
docker build --no-cache . -t kunsol-image
```
Docker image build --> Successfull.

To run the container via: 
```
docker run -v $(pwd):/home/node/app/ --name konsul kunsol-image
```
to build our website we use ```serve -d```:
_step 1 :_ Copy the content of dist/ folder from the container to host's working directory
```
docker cp konsul:/home/node/build/dist ./dist
```
_step 2 :_ launch the website with the command serve
```
serve -d dist/
```
To install ```serve``` type the following command:
```
sudo snap install serve
````
If deployed correctly, our website can be visited via: http://40.87.87.148:8080/

## DockerHub - GitHub Automated builds (CI)
Image building can be automated after connecting dockerhub image repo to the appropriate github repo. Build instances can be viewed and monitord in the timeline section.

![DockerHub build timeline](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/autobuilds.png)

Docker hub repository is connected with github, automatic build is configures on both the master and development branch.
Repo on docker hub: https://hub.docker.com/r/somayyah/konsul.

## Continuous deployment using Rancher
Using Rancher, we can automate our containers deployment process. Setting rancher is as simple as running any ther generic container. Using **rancher:stable** docker image we can deploy rancher with the following command:

```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  rancher/rancher:latest
```
Rancher uses the ports 80 and 443, make sure they can be accessable. To access the rancher CPanel, go to ```https://vm-ip```.
After setting the admin password, clusters configuration can be initiated.

