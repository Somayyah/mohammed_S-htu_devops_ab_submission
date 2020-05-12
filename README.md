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

To access the website visit http://40.87.87.148:8080/___explore.

## Gridsome CI/CD - Automated Gridsome deployment with Docker and Git

Manually setting the infartructure, deploying the website, tracking code changes and testing them is tiresome and leads to many conflicts and is the total opposite to what DevOps stands for. This can be avoided by automating the process using a container based approach. With containarization, we can setup our infrastructure as many times as we want in a negligeble time, while ensuring the same result everytime.

### Gridsome build with Docker
 __Goal:__ Build an image named gridsome-docker that contains all the necessary dependancies to run our website. 

#### Image Dockerfile 

```
FROM node:14.2.0-alpine3.10

RUN apk update && apk upgrade
RUN apk add git yarn python
RUN npm install --global chokidar
RUN npm install sharp
RUN npm install --global @gridsome/cli
RUN git clone https://github.com/Somayyah/htu-devops-konsul-web.git
RUN cd htu-devops-konsul-web/;
RUN npm rebuild
RUN yarn
RUN gridsome develop
```
To build the image use the command:
```
docker build . -t gridsome-docker
```
Docker image build --> Successfull.

Website can be visited via: http://40.87.87.148:8080/___explore
