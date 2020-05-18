# Container Based Website Deployment - Kunsol Group

## Introduction

As per the request of the Kunsol group, this report describes the process and the finished tasks for the Konsul website. This document provides a comprehensive list of all the tools ranging from the collaboration platform and monitoring tools, to orchestration and containerization tools. The following procedure section explains our reasoning and thought process behind  the many design choices that were made. Additionally, it is also displays the configurations and the diagram section.

## Tools and Services Used
1. Rancher:stable container.
2. Azure pipelines.
3. Git / github.
4. Gridsome: A Vue.js framework.
5. Nextcloud.
6. statping:v0.90.36 Docker image.
7. Buttercup: Passwords management.

## Gridsome Local Deployment Testing

![console](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/gridsome | width=100)
 
To access the website visit http://localhost:8080/

## Gridsome CI/CD - Automated Gridsome Deployment with Docker and Git

Manually setting the infartructure, deploying the website, tracking code changes and testing them is tiresome and leads to many conflicts, the total opposite to what DevOps stands for. This can be avoided by automating the process using a container based approach. With containarization, we can setup our infrastructure as many times as we want in a negligeble time, while ensuring the same result everytime.

### Gridsome Build with Docker
 __Goal:__ To build an image named gridsome-docker that contains all the necessary dependancies to run our website. 

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
If deployed correctly, our website can be visited via: http://VM-IP:8080/

## DockerHub - GitHub Automated Builds (CI)
Image building can be automated after connecting DockerHub image repository to the appropriate github repository. Build instances can be viewed and monitord in the timeline section.

![DockerHub build timeline](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/autobuilds.png)

THe DockerHub repository is connected with GitHub, automatic build is configures on both the master and development branch.
Repo on docker hub: https://hub.docker.com/r/somayyah/konsul.

## Continuous Deployment Using Rancher
Using Rancher, we can automate the deployment process for our containers. Setting Rancher is as simple as running any other generic container.

### Setting Up Rancher
Using **rancher:stable** Docker image we can deploy Rancher with the following command:

```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  rancher/rancher:latest
```
Rancher uses the ports 80 and 443, make sure they can be accessable. To access the Rancher CPanel, go to ```https://vm-ip```.
After setting the admin password, clusters configuration can be initiated.
To build a new cluster:

__Step 1:__ From Rancher's main page click on ```add cluster``` button
![add cluster](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/cluster.png)
__Step 2:__ We are going to deploy using Azure AKS so we will select it.
__Step 3:__ Fill the relevent data like the name and ID's.
After creating the cluster, we can view it in the global view. It needs some time to become active.
![global](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/global.png)

### Rancher Workload Configuration

After experimenting with our website Docker image, It became obvious that the container exploits the port 5000 to run the website, so it needs to be mapped with the port 80 on Rancher to make it accessable.<br>

__Step 1:__ From our cluster go to default.<br>
![global](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/def.png)<br>
__Step 2:__ On the right side of the screen select ```Deploy```.<br>
__Step 3:__ Set the name to what you like and the Docker image, in our case we will use ```somayyah/konsul```.<br>
__Step 4:__ Click on add port and set the feilds as the following:<br>
* Port Name	: any name.<br>
* Publish the container port : 5000<br>
* Protocol	: TCP<br>
* As a	: Layer-4 load balancer<br>
* On listening port : 80<br>
__Step 5:__ Click save and wait for the changes to be applied. To view our deployed site, click on ```80/tcp``` located under the workload name.<br>
![global](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/ip.png)<br>
Our website is now deployed and can be accecced via: http://20.185.39.108/<br>

### Grafana and Prometheus Monitoring <br>

__PREREQUISITE:__<br>
* Make sure that you are allowing traffic on port 9796 for each of your nodes because Prometheus will scrape metrics from here.<br>

To monitor our Kubernetes cluster we can configure Rancher to deploy Prometheus, by following the steps from the official documentation:<br>

> 1. From the **Global** view, navigate to the cluster that you want to configure cluster monitoring.<br>
> 2. Select **Tools** > **Monitoring** in the navigation bar.<br>
> 3. Select **Enable** to show the Prometheus configuration options. Review the resource consumption recommendations to ensure you have enough resources for Prometheus and on your worker nodes to enable monitoring. Enter in your desired configuration options.<br>
> 4. Click **Save**.<br>
To access the Grafana dashboard can be done from global view -> cluster dashbourd -> click on Grafana icon.<br>
![dashboard](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/dashboard.png)<br>

## Nextcloud - PostgreSQL Setup and Deployment<br>
Deploying Nextcloud in congugation with PostgreSQL database is a rather simple task, to successfuly perform the setup I followed these steps:
__Step 1:__ On our cluster, we create the nextcloud workload with these parameters:
* Name: nextcloud-website
* Docker Image: nextcloud
* Port Mapping: 
> * Port Name	: any name.<br>
> * Publish the container port : 80<br>
> * Protocol	: TCP<br>
> * As a	: Layer-4 load balancer<br>
> * On listening port : 80<br>
* Environment variables:
> * POSTGRES_DB=postgressdb
> * POSTGRES_USER=user-name
> * POSTGRES_PASSWORD=db-password
> * POSTGRES_HOST=postgressdb
> * NEXTCLOUD_ADMIN_USER=admin
> * NEXTCLOUD_ADMIN_PASSWORD=admin-pass
> * NEXTCLOUD_DATA_DIR=/var/www/html/data
* Volumes:
> * Volume Name: nextcloud
> * Path on the Node: /nextcloud
> * The Path on the Node must be: a directory or create
> * Mount Point: /var/www/html

Netxcloud setup, done.
__Step 2:__ On our cluster, we create the database workload with these parameters:
* Name: postgressdb
* Docker Image: postgres
* Environment variables:
> * POSTGRES_DB=postgressdb
> * POSTGRES_USER=user-name
> * POSTGRES_PASSWORD=db-password

database setup, done.

__Step 3:__ After the deployment finishes, we setup the admin account as follows:
1. Go to the new Nextcloud IP, in our case it's: http://40.76.222.167/
2. When prompted to create an admin account, enter the admin username and password that we previously defined in the nextcloud workload.
3. Wait untill the setup finishes.

After accessing the admin portal, you can add users, groups and try all of the other available services.

Admin account setup, done.

Nextcloud test account:

__username:__ Linux and DevOps
__password:__ Linux and DevOps

# Statping Setup
