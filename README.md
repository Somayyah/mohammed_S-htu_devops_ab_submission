# Container based website deployment - kunsol group

## Introduction

As per request of Kunsol group, this report describes the process and the finished tasks for the konsul website. A comprehensive list of all the tools ranging from collaboration platform and monitoring tools, to orchestration and containerisation tools is provided. Then the procedure section which explains the thought process, and the reasoning behind many design choices, followed up with the configurations and the diagrams sections.

## Tools and services used:
1. Rancher:stable container.
2. Azure pipelines.
3. Git / github.
4. Gridsome: A Vue.js framework.
5. Nextcloud.
6. statping:v0.90.36 docker image.
7. Smartlook: website analytics.
8. buttercup: Passwords management.

## Gridsome Deployment Testing - Done

![console](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/gridsome)

To access the website visit http://40.87.87.148:8080/___explore.

## Gridsome CI/CD - Automated Gridsome deployment with Docker and Git

Manually setting the infartructure, deploying the website, tracking code changes and testing them is tiresome and leads to many conflicts and is the total opposite to what DevOps stands for. This can be avoided by automating the process using a container based approach. With containarization, we can setup our infrastructure as many times as we want in a negligeble time, while ensuring the same result everytime.

### Gridsome build with Docker
 __Goal:__ Build an image named gridsome-docker that contains all the necessary dependancies to run our website. 

Dockerfile is created : 

```
FROM node:12-alpine

# Install build tools
# Needed by npm install
RUN apk update && apk upgrade
RUN apk --no-cache add --virtual util-linux native-deps git\
  g++ gcc libgcc libstdc++ linux-headers make python

# Manually change npm's default directory
# to avoid permission errors
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

# Install Gridsome globally
USER node
RUN npm i -g gridsome

# Install the application
COPY --chown=node:node ./ /home/node/build/
WORKDIR /home/node/build
USER node
RUN npm cache clean --force
RUN npm clean-install

# Remove the project files
# but keep the node modules
RUN cd .. && \
    mv build/node_modules ./ && \
    rm -rf build && \
    mkdir build && \
    mv node_modules build/


WORKDIR /home/node
# Get the source code without node_modules
# Then build the site
CMD cp -r app temp && \
    rm -rf temp/node_modules && \
    cp -r temp/* build/ && \
    cd build && \
    ~/.npm-global/bin/gridsome build
```
