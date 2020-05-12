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
