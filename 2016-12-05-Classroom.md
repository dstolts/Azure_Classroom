---
layout: post
title:  "How Azure and DevOps Enabled a Major US Research University to Deploy Backend and Student Machines for Class"
author: "Dan Stolts"
author-link: "#"
#author-image: "{{ site.baseurl }}/images/authors/photo.jpg"
date:   2016-12-05
categories: DevOps
color: "blue"
#image: "{{ site.baseurl }}/images/imagename.png" #should be ~350px tall
excerpt: A Major US Research University US partnered with Microsoft to learn how Azure infrastructure, a Web App and DevOps best practices could better address their need to quickly, easily and consitantly onboard classroom and student infrastructure. This included: backend servers, storage and networking as well as student VMs, organizational authentication, private and public shares for students to use to submit homework or collaborate on teams. Read about the solution and how it was implemented. 
language: English
verticals: [Business to Business]
---

A Major US Research University US partnered with Microsoft to learn how Azure infrastructure, a Web App and DevOps best practices could better address their need to quickly, easily and consitantly onboard classroom and student infrastructure. This included: backend servers, storage and networking as well as student VMs, organizational authentication, private and public shares for students to use to submit homework or collaborate on teams. This class could have in excess of 400 students each term so automation was paramount on the needs list. The proof of concept (PoC) project made use of the following services and practices:

- Azure AD Integration
- Azure Blog Storage
- Infrastructure as Code
- Continuous Integration
- Monitoring
- Automated Deployment
- Automated Distruction

 
The project took place over the course of 2 months with the premise of migrating all infrastrucatue needed to Azure, re-creation of a web portal, and enabling best practices for continuous integration, Automated Deployment and Automated Distruction for when the class ended.  There was also a need to monitor usage patterns to make sure students were not manually standing up significant hardware that would ultimately be charged back to the University.  The hack team was composed of members from both Microsoft and the University and included:

- A Major US Research University – Professor
- A Major US Research University - Azure Project Lead and Sr TA
- Dan Stolts – Senior Technical Evangelist, Microsoft, [@itproguru](https://twitter.com/itproguru) 
- Ian Philpot – Senior Technical Evangelist, Microsoft, [@tripdubroot](https://twitter.com/tripdubroot)
- Heather Shapiro – Technical Evangelist, Microsoft, [@microheather](https://twitter.com/microheather)
- Jessica Deen – Technical Evangelist, Microsoft, [@jldeen](https://twitter.com/jldeen)

## Customer profile ##

This Major US Research University is a world class university that is known for there leading edge stance on utilization of technology. They are a Premier Technology School in the world.  Top 5 overwall university in the world.
The Institute is an independent, coeducational, privately endowed university, organized into five Schools (architecture and planning; engineering; humanities, arts, and social sciences; management; and science). It has some 1,000 faculty members, more than 11,000 undergraduate and graduate students, and more than 130,000 living alumni. They would, for now, prefer to remain annonymous so this document will refer to this University as simply "The University". The University provides its students with a platform to manage their infrastructure, submit homework, collaborate in teams, collaborate with professors. It gives students a single command to run to login to their automatically generated hardware infrastructure, provides students the capability to stand up additional infrastructure so they can thuroughly evaluate the performance of the software they create on different classes of machines and even clusters of servers. A large (6 or more) Teacher Assistants (TA) staff helps students as needed so they are also automatically granted access rights to the machines the students use. These TA's manage many aspects of the class including grading all homework, making sure the students are fully prepared to start class on day 1 with no technical surprises. They also manage the backend infrastructure that are used for submitting homework and exams. 

## Customer testimony ##

<iframe src="https://channel9.msdn.com/Series/Customer-Solutions-Workshops/How-Azure-Web-Apps-and-DevOps-help-Roomsy-make-changes-faster-with-lower-risk/player" width="960" height="540" allowFullScreen frameBorder="0"></iframe>


## Architecture overview ##

Currently Roomsy operates the [http://pagodabox.io/](http://pagodabox.io/) site in a cloud solution for hosting LAMP applications.

Roomsy’s solution contains three PHP applications and two MySQL databases that are located on the same server. There are also tasks that run once every 15 minutes. The task has to invoke PHP pages in order to invoke some sync mechanisms with external providers like Booking.com or Expedia. The pages are not secured. 

The list of the applications:

- Channel Manager (cm.roomsy.com) + two tasks (every 15 minutes)
- Roomsy Property Management System/API (api.roomsy.com, pms.roomsy.com + two tasks (hourly and daily)
- Roomsy Web Site CMS (pages.roomsy.com)

The applications use PHP 7.0, CodeIgniter 3.1 PHP framework, and ImageMagic extension with a MySQL back end.

MySQL connection strings (credentials) are stored in the PHP environment file.

MySQL databases are 800 MB only and they are growing slowly. 
It’s possible to stop the applications for 10-30 minutes in order to update connection strings and finish migration tasks.

The Roomsy domain is configured outside pagodabox.io using a third-party domain registrant. Here are the configuration details:

![Configuration details]( {{ site.baseurl }}/images/roomsy01.png)

The pagodabox.io cloud doesn’t support CName for Custom Domain Names, so in order to configure the domain, you have to provide A records only.
 
## Problem statement ##

The application enables management of different properties including hotels, motels, RV parking camps, and so on. Managers use the solution to order and book rooms, generate reports, and check guests in and out. As such, any delays are critical because the whole business shuts down. As a global solution, there isn’t a window of time where maintenance can be permitted to bring the system down.
 
We spent half the day establishing a value stream map (VSM) of the current delivery process, from conception to production. The VSM allowed Roomsy to realize that its current way of developing and deploying their solution leaves them vulnerable to significant issues, with little or no ways to mitigate risks.

![Creating the value stream map]( {{ site.baseurl }}/images/roomsy02.jpg)

While Dev and Staging environments did exist, they were not utilized in the current process.

The process can be described in two steps:

- Write code.
- Copy code to production servers.

While this seems to work today, this approach means there is no easy way to back out if a change breaks the production environment. There is no easy way to test new features without impacting the production environment and existing customers. And no way to ensure that availability is maintained since the entire solution currently runs on a single virtual machine.

## Project objectives ##

In order to create a prototype, we have to execute the following actions:

- Web portal migration. Create three Azure Web Apps: configure PHP, deployment, slots, and Virtual Network.
- The database migration. Create a virtual machine- based on Linux and set up RAID 0. The virtual machine should be deployed at the same Virtual Network.
- Deploy and set up MySQL using the most recent snapshot of the database.
- The tasks. Implement Azure Functions.
- Implement a Continuous Integration model with the capacity to roll back any changes. It should be based on an infrastructure defined by templates and automation to ensure that it can be replicated easily.

### Migration plan ###

Due to pagodabox.io limitations, we cannot make a smooth migration of all components at once to production. Instead, we have to divide the migration process into three steps:

- Create a working prototype in Azure. MySQL database should be reachable outside the local network.
- Make sure that MySQL in Azure contains up-to-date data and redirect pagodabox.io applications to it. 
- Once Azure and pagodabox.io applications can work with MySQL in Azure, update DNS records. 

Using this approach, we would affect users only during the MySQL migration phase, which should not take much time. We agreed that it’s possible to notify users in advance about maintenance work. In order to migrate the database, we would stop all services, create a hot copy of the database, and restore it in Azure. We could test this approach in advance to make sure we knew all possible issues and timing. 
 
All components would be deployed using the new [Azure portal](http://portal.azure.com) in the same resource group. Potentially we could create a script for Azure Resource Manager, but in this case we wanted to educate the partner and show how to deploy all components step by step.

## Continuous Integration plan ##

The following processes were included:

- As part of the Azure Migration POC, we would identify a Continuous Integration process that would automatically push the Master branch of the code to a dev slot in the Azure Resource Group each time the branch is merged or updated. 
- The Dev environment in Azure would be turned into a JSON template to facilitate the capabilities of automated deployment.
- Implement an availability set of virtual machines deployed across fault domains and update domains. Availability sets will ensure that the Roomsy application is not affected by single points of failure, like the network switch or the power unit of a rack of servers.

## Solutions, steps, and delivery ##

### Classroom Deployment ###

Creating a new portal is not challenging. Just make sure to use the same resource group for all components and service plans in the same region (and create a new group for the first portal). For example, we decided to use East US due to customer location:

### Azure Command Line (Azure-Cli)

The Azure-CLI provides a cross-platform command line interface for developers and IT administrators to develop, deploy and manage Microsoft Azure applications. The Azure Classroom project provides a series of scripts based on the Azure-CLI, written in Bash, that will help you create virtual machine images and deploy them for use by students. These scripts should be accessible to users on both Mac OSX and various Linux flavors like Ubuntu or Fedora.

The scripts assume you’ve logged into the Azure-CLI and selected the subscription you want to target. They provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

Finally, a script the students will run is provided. This script pulls the gold image from the share location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM.

### Azure SDK for Python

The Azure SDK for Python is a set of libraries which allow you to work on Azure for management, runtime or data needs. The Azure Classroom project provides a series of scripts using the Azure SDK for Python, that will help teachers and students create virtual machine images and deploy them for use by the students. These scripts will require that the user has Python installed on their computer, which can be downloaded from the [Python site](https://www.python.org/downloads/). There are also several python libraries that are necesssary for the scripts to run but the scripts will handle checking for them and installing them if they are not found.

The SDK requires the user to have an Active Directory account created on their Azure subscription. 

To do this:
- Login to http://manage.windowsazure.com
- Click the button for active directory
- Select the default directory
- Click Users
- Click “Add User” at the bottom
- Create a new user in your organization
 -	Give the user Global Admin rights
- Note the password for your new user
- Go to settings 
- Click the Administrator Tab
- Select Add at the bottom and enter the new email address that you just created
 -	Select the subscription you want them to be added to
- Log out of the Azure portal and relogin with your new Active Directory email
- Change your password
- Go to settings 
- Mark down your subscription id

To run the scripts, you will need to cd into the proper folder, and run "python *script name*". The scripts will ask for your Azure credentials from the new Active Directory account that was just created. After you do this once, it will create a file for the user with the credentials so that the user does not have to keep entering their information in.

Similarly to the Azure CLI scripts, the python scripts provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

Finally, a script the students will run is provided. This script pulls the gold image from the share location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM.


We will use additional deployment slots to deploy the portals from GitHub to Azure. We use this approach for testing purposes, not just for the migration but for future development as well. Once testing is done, we will be able to swap the slots. So, a new slot should be created for each of the portals. More information about deployment slots is available [here](https://azure.microsoft.com/en-us/documentation/articles/web-sites-staged-publishing/). 

Make sure that the slots are created using the same application plan as production so that the slots share resources with components in production. That’s why, if there are any load tests, the test slots should be moved to a separate application plan first. 

![Slot creation]( {{ site.baseurl }}/images/roomsy06.png)

If we were going to use FTP for any tasks, deployment credentials would have to be provided. But we don’t recommend doing this because the most important features are available through a KUDU panel (for example, [https://roomsywebapp1.scm.azurewebsites.net/](https://roomsywebapp1.scm.azurewebsites.net/)). **Deployment source** for the **testing** slot should be configured in order to use GitHub.

**Note** GitHub integration should be activated for the testing slot only. The source should be deployed to the testing slot only. Once all testing activities are completed, it will be possible to switch the testing and production slots. We are not going to set up any deployment sources for production deployment.

![Deployment sources]( {{ site.baseurl }}/images/roomsy07.png)

The applications can potentially have some settings, including a connection string. Using the portal, we can apply environment settings (Application settings), handler mappings, default documents, and a new root folder:

![Application settings]( {{ site.baseurl }}/images/roomsy08.png)

All other PHP settings should be applied manually using standard PHP files. For more information about settings for PHP sites, see the following:

- [https://azure.microsoft.com/en-us/documentation/articles/web-sites-php-configure/](https://azure.microsoft.com/en-us/documentation/articles/web-sites-php-configure/)
- [https://azure.microsoft.com/en-us/documentation/articles/app-service-web-php-get-started/]( https://azure.microsoft.com/en-us/documentation/articles/app-service-web-php-get-started/)
 
At the hackfest, we discovered that all settings would be provided using environment PHP variables. In this case, it’s possible to provide them using the App Settings tab, so it isn’t necessary to edit any files directly. Additionally, it’s possible to provide different settings for testing and production slots (just use the Slot Settings checkbox to freeze a record for any selected slot).

### Virtual Network ###

In order to establish connections between student machines and the private and public shares as well as to allow the students to collaborate or share their machine with other students or TA's we created virtual machines on the same network which we created in scripts as seen in the image which shows the Linux Bash with Azure CLI version of the script.
 
![Share Same Network]( {{ site.baseurl }}/images/classroom10.png)

Creating the network is done prior to creation of any virtual machines. Of course, it’s possible to reconfigure any existing virtual network but it requires PowerShell knowledge or access to the old portal. So, prior to creating any virtual machines, we will create the network, subnet and network security group.  Finally as we deploy virtual machines we will creat the network interface cards used for the machine. Within the portal we can see graphically what was created. 

![Networking tab]( {{ site.baseurl }}/images/classroom11.png)

More details about virtual networks are available [here](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-vnet-arm-cli). Notice also that in this article there is a dropdown box to see how to do this on many different platforms.

Note that it requires about several minutes to configure a virtual network. **Don’t create any virtual machines before the virtual network is done.**

Once the virtual network is created, it’s possible to create a virtual machine. In this step you can specify an already existing virtual network:

![Creation of virtual machine]( {{ site.baseurl }}/images/classroom12.png)

Once the virtual machine is created, it’s possible to connect to the virtual machine with either Remote Desktop Client or SSH depending on the OS. This is possible because when we created the network security group we enable ports 22 and 3389 (RDP):

![Modify network security group settings]( {{ site.baseurl }}/images/classroom13.png)

By adding new inbound rules, it’s possible to specify any custom port or select a service from the list. (SSH then RDP was selected in our case.)

Once the port is open, it’s possible to connect the virtual machine using a local IP address.  Most of the machines we created were Linux so our tool of choice for connecting was [PuTTY]( http://www.putty.org/). 


Dan stopped here!!!


![Test connection status]( {{ site.baseurl }}/images/roomsy14.png)

The Kodu tool allows us to run the console windows in the browser, but a standard ping command doesn’t work there. Instead, it’s possible to use tcpping.exe.

![Using tcpping.exe]( {{ site.baseurl }}/images/roomsy15.png)

### The database migration ###

Microsoft Azure already contains several ready-to-use images for different Linux operating systems. For example, we could use Ubuntu:

![Using Ubuntu]( {{ site.baseurl }}/images/roomsy16.png)

Resource Manager will be used by default to deploy a virtual machine.

Using the wizard, we have to provide some basic parameters on the first step: Name, User Name, SSH public key and Location. The location must be the same (Central Canada, for example) for all services. SSD allows us to get a better performance, which is critical for database solutions.

![Provide parameters]( {{ site.baseurl }}/images/roomsy17.png)

In the second step, we have to select a service plan. In the case of database solutions, we have to select a service plan that supports at least two data disks. Using the disks, we are going to create a RAID 0 array to increase performance. 

Once the plan is selected, we can provide network settings. Here we have to select a virtual network that we created earlier. 

Additionally, we can provide two storage names. It’s better to assign more friendly names in this step. 

![Friendly storage name]( {{ site.baseurl }}/images/roomsy18.png)

Once the virtual machine is created, we can connect to it using Putty or any other SSH client. But before doing that, it’s better to create two data disks for our RAID array. Right after that we can connect the virtual machine and start implementing all configuration tasks.

In the next steps we have to create RAID and “copy” the existing database. 
In order to create the RAID array, we can refer to the following: 

- [https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-configure-raid/](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-configure-raid/)
- [https://blogs.msdn.microsoft.com/azureossds/2016/04/25/migrating-mysql-database-from-os-disk-to-data-disk-on-azure-linux-vm/](https://blogs.msdn.microsoft.com/azureossds/2016/04/25/migrating-mysql-database-from-os-disk-to-data-disk-on-azure-linux-vm/)

Additionally, we can use the mysqldump tool to get a current snapshot of the database, so that it doesn’t affect customers. More information about the tool can be found [here](https://blogs.msdn.microsoft.com/drougge/2016/02/25/migrating-mysql-db-to-azure-linux-centos-vm-using-mysqldump-and-scp/). 

Before starting to create any databases, it’s a good idea to generalize the image. It will help us to recreate the virtual machine with all needed settings there. Before generalizing our virtual machine, we have to make sure that RAID 0 is configured, MySQL is installed, and MySQL uses RAID 0 disk to store all database files.

**Note** MySQL stores all DB files on the system disk by default. Therefore, it’s important to change the configuration of MySQL. Follow the guidance here: [https://blogs.msdn.microsoft.com/azureossds/2016/04/25/migrating-mysql-database-from-os-disk-to-data-disk-on-azure-linux-vm/](https://blogs.msdn.microsoft.com/azureossds/2016/04/25/migrating-mysql-database-from-os-disk-to-data-disk-on-azure-linux-vm/)

Finally, we can make a snapshot. The steps on capturing a snapshot can be found here: [https://blogs.technet.microsoft.com/canitpro/2016/08/31/step-by-step-capture-a-linux-vm-image-from-a-running-vm/](https://blogs.technet.microsoft.com/canitpro/2016/08/31/step-by-step-capture-a-linux-vm-image-from-a-running-vm/)

Once we have the snapshot, we can use the following procedure to redeploy our virtual machine based on the snapshot: [https://blogs.technet.microsoft.com/canitpro/2016/09/14/step-by-step-deploy-a-new-linux-vm-from-a-captured-image/](https://blogs.technet.microsoft.com/canitpro/2016/09/14/step-by-step-deploy-a-new-linux-vm-from-a-captured-image/)

**Note** We used only step 2 of this procedure because we already had all other network components.

For testing purposes, do not use the database in production. It’s better to create one more virtual machine. In this case, we can use the cheapest virtual machine without RAID and SSD—just for testing (not performance testing). Make sure the connection string for Testing slots refers to the testing DB.

### Tasks ###

In order to execute the task, we can use Azure Functions, which can run in the same service plan. It’s still not clear how the PHP page is secured; however, we should not have any problems there. The script is not complex. For example, we can use something like this (C#):

```

using System;

public async static void Run(TimerInfo myTimer, TraceWriter log)
{
    log.Info($"C# Timer trigger function executed at: {DateTime.Now}");   
    HttpClient client=new HttpClient();
    await client.GetAsync("http://www.microsoft.com");
}

```

### Backup tips ###

We used mysqldump to create the required backups. The script should create a local file. Once the file is created, it should be copied to Azure Blob storage. A cross-platform command line tool can be used for this task. Azure Blob storage should be created (private blob).

### Continuous Integration ###

Roomsy uses a private GitHub repository where it stores the solution code. This provides Roomsy with an affordable way to ensure speed, data integrity, and support for distributed, non-linear workflows.

The master branch of the repo will be pushed to the Dev slot in the Roomsy Resource group. Please note that GitHub integration will be activated for the Dev slot only. Once all testing activities are completed, it will be swapped with the production slots. We are not going to set up any deployment sources for production deployment.

![Deployment slots]( {{ site.baseurl }}/images/roomsy19.png)

![GitHub deployment]( {{ site.baseurl }}/images/roomsy20.png)

![Project and branch]( {{ site.baseurl }}/images/roomsy21.png)

### Infrastructure as Code ###

We split the Infrastructure as Code section into two sections:

- Network configuration
- Linux/MySQL back end

The network configuration was defined in a JSON template. 

The first template is needed to create the following items in the Resource group:

- Virtual Network.
- Virtual Network interface card for the Linux host that will run MySQL.
- Network Security Group that will look incoming ports to SSH (TCP/22) and MySQL (TCP/3306).
- A public IP address for the MySQL host with DNS name label to avoid hardcoding IP addresses.
- A Point to Site VPN Gateway to allow the WeApp to connect to the back-end database.

![First template]( {{ site.baseurl }}/images/roomsy22.jpg)

The second JSON template is to deploy a back-end Linux server with a proper RAID configuration to host the DB.

To perform that, we created the server manually, attached two empty 512 GB disks with no cache, [configured the two-2 disk RAID 0 array](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-configure-raid/), installed MySQL, configured MySQL to use the RAID array to store the data, and imported test data from Roomsy’s existing server.

Once the machine was complete and tested, we used the information included in the following posts to capture the machine and generate a JSON file that we modified for our needs:

- [Step-by-Step: Capture a linux VM Image from a running VM](https://blogs.technet.microsoft.com/canitpro/2016/08/31/step-by-step-capture-a-linux-vm-image-from-a-running-vm/)
- [Step-by-Step: Deploy a new Linux VM from a captured image](https://blogs.technet.microsoft.com/canitpro/2016/09/14/step-by-step-deploy-a-new-linux-vm-from-a-captured-image/)

The modifications done to the JSON files included changing the Login credentials from a Password to a Public Certificate.

In the variable section of the JSON template, we replaced the following parts:

![Replaced parts]( {{ site.baseurl }}/images/roomsy23.png)

We replaced them with:

![New parts]( {{ site.baseurl }}/images/roomsy24.png)

And in the virtual machine resource definition, changed the “osprofile” to: 

![Osprofile change]( {{ site.baseurl }}/images/roomsy25.png)

## General lessons ##

Some key points to consider:

- MySQL migration requires some knowledge of operations rather than development. It’s important to understand how to increase performance using RAID and how to use data disks to move database files there.
- Thanks to Azure Virtual Network and Point to Site settings (and a Virtual Gateway) there, it’s possible to use Azure Web Apps and virtual machines in the same network to hide virtual machines disabling public IP addresses. It’s really useful in the case of databases.
- It’s important to divide the migration process into several independent steps due to delays in domain records update. When migrating from third-party services, it’s not always possible to use CName. Therefore, it’s not always possible to use Traffic Manager and migration to production can be challenging.
- It’s important to understand the sequence of steps during migration. For example, it’s better to create a Virtual Network using the Azure Web Apps interface than the virtual machine interface. That way, it’s not necessary to reconfigure the network from Site to Site to Point to Site.
- Automated testing needs to always be a top priority, from unit tests to integration and load tests. Being confident in the quality of the code should be a prerequisite in order to release it.
- Automation of the deployment for the development, testing, and production environments provides certitude that standards are maintained and that each environment is true to design and will lower failure risks.

## Conclusion ##

We could use both infrastructure as a service (IaaS) and platform as a service (PaaS) approaches to guarantee the best result. Migration to Azure Web Apps is not challenging at all due to PHP 7 support and ability to use the staging environment that is integrated with GitHub. Creating the right virtual machine for MySQL is a little tricky but thanks to the generalization process we could build an image with a proper setup. So, it’s really easy to redeploy the virtual machine.

The value stream mapping portion of the hack helped Roomsy see the big picture and understand where automation, proper processes, and DevOps practices can mitigate risks and allow for growth.

A lot of very interesting ideas on how to improve the process were discussed during this Hackfest, some more doable than others. Most importantly, though, Roomsy realized the value of continuously improving and is committed and willing to put a lot of effort into this.
