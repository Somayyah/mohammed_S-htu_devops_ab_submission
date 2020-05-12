FROM node:14.2.0-alpine3.10

RUN apk update && apk upgrade

RUN apk add git yarn python
RUN npm install --global chokidar
RUN npm install sharp
RUN npm install --global @gridsome/cli
RUN git clone https://github.com/Somayyah/htu-devops-konsul-web.git
RUN cd htu-devops-konsul-web/; npm rebuild; yarn

RUN gridsome develop
