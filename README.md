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

Manually deploying the website, tracking code changes and testing them is tiresome and leads to many conflicts and is the total opposite to what DevOps stands for. This can be avoided by automating the process using a container based approach.
