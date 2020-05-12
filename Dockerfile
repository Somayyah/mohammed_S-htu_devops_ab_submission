FROM node:14.2.0-alpine3.10

RUN apk update && apk upgrade
RUN apk add git yarn python
RUN npm install --global chokidar
#RUN apk add libvips
RUN npm install sharp
#RUN node-gyp rebuild 
#RUN npm cache clean --force
#RUN yarn global add @gridsome/cli
RUN npm install --global @gridsome/cli
RUN ls
RUN git clone https://github.com/Somayyah/htu-devops-konsul-web.git
RUN cd htu-devops-konsul-web/;
RUN npm rebuild
RUN yarn
RUN gridsome develop

