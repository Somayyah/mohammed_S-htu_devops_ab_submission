<br>
<div class="row">
  <div class="column">
  </div>
  <div class="column">
    <a href="url"><img src="https://d3pmluylahx1gi.cloudfront.net/wp-content/uploads/2019/08/04212458/Nub8-What-is-Devops.png" align="right" height="100"></a>
  </div>
<a href="url"><img src="https://i0.wp.com/www.hashtagarabi.com/wp-content/uploads/2017/10/20604537_1878331972486933_594423176737691610_n.png?fit=610%2C380&ssl=1" align="left" height="140"></a><br><br><br><br><br><br>
  
# Kunsol Group- Website Deployment

## Introduction

As per the request of the Kunsol group, this report describes the process and the finished tasks for the Konsul website. This document provides a comprehensive list of all the tools ranging from the collaboration platform and monitoring tools, to orchestration and containerization tools. The following procedure section explains our reasoning and thought process behind  the many design choices that were made. Additionally, it is also displays the configurations and the diagram section.
________________________________________________________________

## Tools and Services Used
1. Rancher:stable container - Orchestration.
2. Azure pipelines.
3. Git / github - Code versioning and 
4. Gridsome: A Vue.js framework.
5. Nextcloud.
6. statping:v0.90.36 Docker image.
7. Buttercup: Passwords management.
________________________________________________________________

## Gridsome Local Deployment Testing

![console](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/gridsome)
 
To access the website visit http://localhost:8080/
________________________________________________________________

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

________________________________________________________________
## DockerHub - GitHub Automated Builds (CI)
Image building can be automated after connecting DockerHub image repository to the appropriate github repository. Build instances can be viewed and monitord in the timeline section.

![DockerHub build timeline](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/autobuilds.png)

THe DockerHub repository is connected with GitHub, automatic build is configures on both the master and development branch.
Repo on docker hub: https://hub.docker.com/r/somayyah/konsul.

________________________________________________________________
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
________________________________________________________________

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

Finally we get to access Nextcloud.
![Nextcloudpage](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/nextclouddash.png)

________________________________________________________________
## Statping Setup
Statping provides a status page to monitor websites and applications. It automatically fetchs the application's data render it. It can be paired with MySQL, Postgres, or SQLite on multiple operating systems. Setting up Statping is easy, here is how to do it:

__Step 1:__ On rancher, create a new workload with the following parameters:

* Name: m-statping
* Docker Image: statping/statping:v0.90.36
* Port Mapping: 
> * Port Name	: any name.<br>
> * Publish the container port : 8080<br>
> * Protocol	: TCP<br>
> * As a	: Layer-4 load balancer<br>
> * On listening port : 80<br>
* Environment variables:
> * DB_CONN=sqlite
> * ADMIN_USER=admin
> * ADMIN_PASSWORD=admin-pass
> * DESCRIPTION=any descreption
> * NAME=Dashboard-name
* Volumes:
> * Volume Name: statping
> * Path on the Node: /mydir/my-statping
> * The Path on the Node must be: a directory or create
> * Mount Point: /app
__Step 2:__ After creating our workload, if configured correctly we can now go to it's IP, in our case it's http://40.76.85.251/. After scrolling down to the end of the page, we see the word ```dashboard```, clicking on it leads us to the log in page. We enter our predefined username and password lo log in.
__Step 3:__ Setting up our services to view our websites.
After logging into our dashboard, go to services and click on create.
![create](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/create.png)
Fill the following parameters:
* Service name: name.
* Service Type: HTTP for websites/TCP for servers.
* Service Endpoint (URL): website URL.
* Verify SSL: Greyed out.
Then click on ```create service```. We should see our new services in the service tab, sometimes a refresh is nessecery.
To monitor the Kunsol and nextcloud websites I created the folloing services:
![my services](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/ourservices.png)
![my websites](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/webs.png)


