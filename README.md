<br>
<div class="row">
  <div class="column">
  </div>
  <div class="column">
    <a href="url"><img src="https://d3pmluylahx1gi.cloudfront.net/wp-content/uploads/2019/08/04212458/Nub8-What-is-Devops.png" align="right" height="100"></a>
  </div>
<a href="url"><img src="https://i0.wp.com/www.hashtagarabi.com/wp-content/uploads/2017/10/20604537_1878331972486933_594423176737691610_n.png?fit=610%2C380&ssl=1" align="left" height="140"></a><br><br><br><br><br><br>
  
# Kunsol Group- Website Deployment
## Table Of Content
- [Kunsol Group- Website Deployment](#kunsol-group--website-deployment)
  * [Table Of Content](#table-of-content)
  * [Introduction](#introduction)
  * [Architecture Final Setup - Description](#architecture-final-setup---description)
    + [Tasks finished](#tasks-finished)
    + [Quick access list](#quick-access-list)
    + [Tools and Services Used](#tools-and-services-used)
  * [Tasks](#tasks)
    + [Gridsome CI/CD - Automated Gridsome Deployment with Docker and Git](#gridsome-cicd---automated-gridsome-deployment-with-docker-and-git)
      - [Gridsome Local Deployment - Test](#gridsome-local-deployment---test)
      - [Gridsome Build with Docker](#gridsome-build-with-docker)
      - [DockerHub - GitHub Automated Builds (CI)](#dockerhub---github-automated-builds--ci-)
    + [Continuous Deployment Using Rancher](#continuous-deployment-using-rancher)
      - [Setting Up Rancher](#setting-up-rancher)
      - [Rancher Workload Configuration](#rancher-workload-configuration)
      - [Grafana and Prometheus Monitoring <br>](#grafana-and-prometheus-monitoring--br-)
    + [Nextcloud - PostgreSQL Setup and Deployment<br>](#nextcloud---postgresql-setup-and-deployment-br-)
    + [Statping Setup](#statping-setup)
## Introduction
As per the request of the Kunsol group, this report describes the process and the finished tasks for the Konsul website. This document provides a comprehensive list of all the tools ranging from the collaboration platform and monitoring tools to orchestration and containerization tools. The following procedure section explains our reasoning and thought process behind the many design choices that were made. Additionally, it also displays the configurations and the diagram section.
## Architecture Final Setup - Description
After finishing all of the assigned tasks we will have the following milestones:
1. The Konsul group official website, up and running.
2. Collaboration platform Nextcloud Deployed and ready to use.
3. Statping service configured to monitor Nextcloud and the Konsul website.
This diagram provides an overview of the architecture:
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->
<!DOCTYPE html>
<html>
<head>
<title>devops</title>
<meta charset="utf-8"/>
</head>
<body><div class="mxgraph" style="max-width:100%;border:1px solid transparent;" data-mxgraph="{&quot;highlight&quot;:&quot;#0000ff&quot;,&quot;nav&quot;:true,&quot;resize&quot;:true,&quot;toolbar&quot;:&quot;zoom layers lightbox&quot;,&quot;edit&quot;:&quot;_blank&quot;,&quot;xml&quot;:&quot;&lt;mxfile host=\&quot;app.diagrams.net\&quot; modified=\&quot;2020-05-18T22:25:59.835Z\&quot; agent=\&quot;5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36\&quot; etag=\&quot;05slfLb_ALd-6Z6LlIl2\&quot; version=\&quot;13.0.9\&quot; type=\&quot;device\&quot;&gt;&lt;diagram id=\&quot;DjcGP945Ntph68DPUy3H\&quot; name=\&quot;Page-1\&quot;&gt;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&lt;/diagram&gt;&lt;/mxfile&gt;&quot;}"></div>
<script type="text/javascript" src="https://app.diagrams.net/js/viewer.min.js"></script>
</body>
</html><br>
### Tasks finished 
- [x] Konsul website.
- [x] Nextcloud deployment.
- [x] Statping service deployment.
Progress percentage: %100
### Quick access list
* Rancher CPanel: https://40.87.87.148/
* Konsul website: http://20.185.39.108/
* Nextcloud platform: http://40.76.222.167/
* Statping service: http://40.76.85.251/
### Tools and Services Used
1. Rancher:stable container - Orchestration.
2. Azure pipelines.
3. Git / GitHub - Code versioning and 
4. Gridsome: A Vue.js framework.
5. Nextcloud.
6. statping:v0.90.36 Docker image.
## Tasks
### Gridsome CI/CD - Automated Gridsome Deployment with Docker and Git
Manually setting the infartructure, deploying the website, tracking code changes and testing them is tiresome and leads to many conflicts, the total opposite to what DevOps stands for. This can be avoided by automating the process using a container based approach. With containarization, we can setup our infrastructure as many times as we want in a negligeble time, while ensuring the same result everytime.
#### Gridsome Local Deployment - Test
<a href="url"><img src="https://raw.githubusercontent.com/Somayyah/mohammed_S-htu_devops_ab_submission/master/gridsome.png" align="left" height="300"></a>
<br><br><br><br><br><br><br><br><br><br><br><br><br>
To access the website visit http://localhost:8080/<br>
#### Gridsome Build with Docker
 __Goal:__ To build an image named gridsome-docker that contains all the necessary dependancies to run our website. 
**Image Dockerfile** 
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
Docker image build --> Successful.
To run the container via: 
```
docker run -v $(pwd):/home/node/app/ --name konsul kunsol-image
```
to build our website we use ```serve -d```:
_step 1:_ Copy the content of dist/ folder from the container to the host's working directory
```
docker cp konsul:/home/node/build/dist ./dist
```
_step 2:_ launch the website with the command serve
```
serve -d dist/
```
To install ```serve``` type the following command:
```
sudo snap install serve
````
If deployed correctly, our website can be visited via http://VM-IP:8080/

#### DockerHub - GitHub Automated Builds (CI)
Image building can be automated after connecting DockerHub image repository to the appropriate github repository. Build instances can be viewed and monitord in the timeline section.
![DockerHub build timeline](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/autobuilds.png)
The DockerHub repository is connected with GitHub, the automatic build is configured on both the master and development branch.
Repo on docker hub: https://hub.docker.com/r/somayyah/konsul.

### Continuous Deployment Using Rancher
Using Rancher, we can automate the deployment process for our containers. Setting Rancher is as simple as running any other generic container.

#### Setting Up Rancher
Using **rancher:stable** Docker image we can deploy Rancher with the following command:
```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  rancher/rancher:latest
```
Rancher uses the ports 80 and 443, make sure they can be accessible. To access the Rancher CPanel, go to ```https://vm-IP```.
After setting the admin password, clusters configuration can be initiated.
To build a new cluster:
__Step 1:__ From Rancher's main page click on ```add cluster``` button
![add cluster](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/cluster.png)
__Step 2:__ We are going to deploy using Azure AKS so we will select it.
__Step 3:__ Fill the relevant data like the name and IDs.
After creating the cluster, we can view it in the global view. It needs some time to become active.
![global](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/global.png)
#### Rancher Workload Configuration
After experimenting with our website Docker image, It became obvious that the container exploits the port 5000 to run the website, so it needs to be mapped with the port 80 on Rancher to make it accessible.<br>
__Step 1:__ From our cluster go to default.
<a href="url"><img src="https://raw.githubusercontent.com/Somayyah/mohammed_S-htu_devops_ab_submission/master/def.png" align="left" height="300"></a><br><br><br><br><br><br><br><br><br><br><br><br>
__Step 2:__ On the right side of the screen select ```Deploy```.<br>
__Step 3:__ Set the name to what you like and the Docker image, in our case we will use ```somayyah/konsul```.<br>
__Step 4:__ Click on add port and set the feilds as the following:<br>
* Port Name: any name.<br>
* Publish the container port : 5000<br>
* Protocol: TCP<br>
* As a: Layer-4 load balancer<br>
* On listening port : 80<br>
__Step 5:__ Click save and wait for the changes to be applied. To view our deployed site, click on ```80/tcp``` located under the workload name.<br>
![global](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/ip.png)<br>
Our website is now deployed and can be accecced via: http://20.185.39.108/<br>
#### Grafana and Prometheus Monitoring <br>
__PREREQUISITE:__<br>
* Make sure that you are allowing traffic on port 9796 for each of your nodes because Prometheus will scrape metrics from here.<br>
To monitor our Kubernetes cluster we can configure Rancher to deploy Prometheus, by following the steps from the official documentation:<br>
> 1. From the **Global** view, navigate to the cluster that you want to configure cluster monitoring.<br>
> 2. Select **Tools** > **Monitoring** in the navigation bar.<br>
> 3. Select **Enable** to show the Prometheus configuration options. Review the resource consumption recommendations to ensure you have enough resources for Prometheus and on your worker nodes to enable monitoring. Enter in your desired configuration options.<br>
> 4. Click **Save**.<br>
To access the Grafana dashboard can be done from global view -> cluster dashbourd -> click on Grafana icon.<br>
![dashboard](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/dashboard.png)<br>
### Nextcloud - PostgreSQL Setup and Deployment<br>
Deploying Nextcloud in conjugation with PostgreSQL database is a rather simple task, to successfully perform the setup I followed these steps:
__Step 1:__ On our cluster, we create the Nextcloud workload with these parameters:
* Name: Nextcloud-website
* Docker Image: Nextcloud
* Port Mapping: 
> * Port Name: any name.<br>
> * Publish the container port : 80<br>
> * Protocol: TCP<br>
> * As a: Layer-4 load balancer<br>
> * On listening port: 80<br>
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
__Step 3:__ After the deployment finishes, we set up the admin account as follows:
1. Go to the new Nextcloud IP, in our case it's: http://40.76.222.167/
2. When prompted to create an admin account, enter the admin username and password that we previously defined in the Nextcloud workload.
3. Wait until the setup finishes.
After accessing the admin portal, you can add users, groups and try all of the other available services.
Admin account setup, done.
Nextcloud test account:
__username:__ Linux and DevOps
__password:__ Linux and DevOps
Finally, we get to access Nextcloud.
![Nextcloudpage](https://github.com/Somayyah/mohammed_S-htu_devops_ab_submission/blob/master/nextclouddash.png)

### Statping Setup
Statping provides a status page to monitor websites and applications. It automatically fetches the application's data to render it. It can be paired with MySQL, Postgres, or SQLite on multiple operating systems. Setting up Statping is easy, here is how to do it:
__Step 1:__ On rancher, create a new workload with the following parameters:
* Name: m-statping
* Docker Image: statping/statping:v0.90.36
* Port Mapping: 
> * Port Name    : any name.<br>
> * Publish the container port : 8080<br>
> * Protocol    : TCP<br>
> * As a    : Layer-4 load balancer<br>
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
Then click on ```create service```. We should see our new services in the service tab, sometimes a refresh is necessary.
To monitor the Kunsol and Nextcloud websites I created the following services:
![create](https://raw.githubusercontent.com/Somayyah/mohammed_S-htu_devops_ab_submission/master/ourservices.png)
![create](https://raw.githubusercontent.com/Somayyah/mohammed_S-htu_devops_ab_submission/master/webs.png)<br>
**Conclusion:**<br>
Following a DevOps architecture approach instead of the waterfall approach can be of great help by reducing maintenance and deployment time in exchange for higher productivity and quality. By applying my skills and knowledge to follow this approach, I was able to implement all the required tasks, replicating the results can easily be done without hassle or conflicts.
