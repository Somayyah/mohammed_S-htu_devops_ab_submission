FROM node:14.2.0-alpine3.10 AS builder

#RUN apk update && apk upgrade
RUN apk --no-cache add git g++ gcc libgcc libstdc++ linux-headers make python

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
USER node
RUN npm i --global gridsome

COPY --chown=node:node ./ /home/node/build/
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
