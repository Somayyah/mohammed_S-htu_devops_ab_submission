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
FROM node:14.2.0-alpine3.10 AS builder

RUN apk update && apk upgrade
RUN apk --no-cache add git g++ gcc libgcc libstdc++ linux-headers make python

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
USER node
RUN npm i --global gridsome

COPY --chown=node:node htu-devops-konsul-web/ /home/node/build/
WORKDIR /home/node/build
USER node
RUN npm cache clean --force
RUN npm clean-install

FROM node:14.2.0-alpine3.10
WORKDIR /home/node
USER node
RUN mkdir build .npm-global
COPY --from=builder /home/node/build/node_modules build/node_modules
COPY --from=builder /home/node/.npm-global .npm-global

CMD cp -r app temp && rm -rf temp/node_modules && cp -r temp/* build/ && cd build && ~/.npm-global/bin/gridsome build
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


