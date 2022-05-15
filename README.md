# Deployment GTD application backed by a PostgreSQL database into a AWS cloud environment.


# Create AWS VPC
-Created a AWS virtual private cloud (VPC)
-considering default VPC at designated region.

# Create AWS subnet Allocation
-Provided with subnet associated to EC2.

# Create AWS Instance launch
- Defined with desired AMI.
- Allocated with type of instance.
- Associate security group for instance.
- Specific key name.

# Installing Docker on instance launched
-Defining on User data file for docker installed.
-Automate the DOcker tool to launch and pull the image from repository to create container.

# Created a Postgre Database backend to the application
- Defined postgre database to store user data.
- Specified engine version to run.
- Snapshot been captured for Backup.

# Auto Scaling enabled to handle the load
- Defined with auto scaling for workload and based on reuested hitting the instance.
- Health checks enabled to monitor and arrange the fleet on service.
- Pre-defined AMI, Instance type and user data configurations have been deployed.


# Enhanced approach to run the Application with AWS services
- By using Amazon Elastic Container service (ECS ) 
- Introducing Elastic Load Balancers (ELB) and Route53 specifications.

# Issues en-countered during the techchallenge
- Docker image provided was unable to hold the container runtime, container was created and exiting frequently.
- Tried to troubleshoot the container issue with various docker commands.
- checked and verified to docker serve and accessing the container.

# Docker PS history 
root@ip-172-31-10-170:/home/ubuntu# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                CREATED          STATUS                      PORTS     NAMES
3e2400afdcf1   centos                            "/bin/bash"            4 seconds ago    Exited (0) 4 seconds ago              distracted_thompson
f269866fe360   centos                            "/bin/bash"            55 seconds ago   Exited (0) 54 seconds ago             awesome_lalande
###f68afaeec24c   servian/techchallengeapp:latest   "./TechChallengeApp"   13 minutes ago   Exited (0) 13 minutes ago             interesting_heyrovsky


# Docker logs captured for exiting frequently


root@ip-172-31-10-170:/home/ubuntu# docker logs --follow a75f73bc7402
[root@a75f73bc7402 /]# exit


root@ip-172-31-10-170:/home/ubuntu# docker logs f68afaeec24c

 .:ooooool,      .:odddddl;.      .;ooooc. .l,          ;c.    ::.      'coddddoc'         ,looooooc.
'kk;....';,    .lOx:'...,cxkc.   .dOc....  .xO'        ,0d.   .kk.    ,xko;....;okx,     .xkl,....;dOl.
:Xl           .xO,         :0d.  ;Kl        ,0o       .dO'    .kk.   :0d.        .d0:   .xO'        lK:
.oOxc,.       lKl...........oK:  :Kc         l0;      :Kc     .kk.  .Ok.          .kO.  '0d         '0d
  .;ldddo;.   oXkdddddddddddxx,  :Kc         .kk.    .Ox.     .kk.  '0d            d0'  '0d         '0d
       .cOk.  lKc                :Kc          :0l    o0;      .kk.  .Ok.          .k0'  '0d         '0d
         cXc  .xO;         ..    :Kc          .d0'  ;0o       .kk.   :0d.        .dN0'  '0d         '0d
,c,....'cOx.   .lOxc,...':dkc.   :Kc           'Ox',kk.       .kk.    ,xko;'..';okk00,  '0d         '0d   ';;;;;;;;;;,.
'looooool;.      .;ldddddo:.     'l'            .lool.         ::       'coddddoc'.;l.  .l;         .c;  .cxxxxxxxxxxo.

This application is used as part of challenging potential candiates at Sevian.

Please visit http://Servian.com for more details

Usage:
  TechChallengeApp [command]

Available Commands:
  help        Help about any command
  serve       Starts the web server
  updatedb    Updates DB

  FOR clear logs capture, please refer in the edit of Readme file.
