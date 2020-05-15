FROM node:14.2.0-alpine3.10 AS builder

#RUN apk update && apk upgrade
RUN apk --no-cache add git g++ gcc libgcc libstdc++ linux-headers make python

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
USER node
RUN npm i --global gridsome

COPY --chown=node:node htu-devops-konsul-web/ /home/node/build/
RUN echo && ls /home/node/build/ && echo
WORKDIR /home/node/build
USER node
RUN npm cache clean --force
RUN npm clean-install

CMD ~/.npm-global/bin/gridsome build && serve -d dist/
