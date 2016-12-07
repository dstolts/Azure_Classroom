---
layout: post
title:  "How Azure and DevOps Enabled a Major US Research University to Deploy Backend and Student Machines for Class"
author: "Dan Stolts, Heather Shapiro, Ian Philpot, Jessica Deen"
author-link: "#"
#author-image: "{{ site.baseurl }}/images/authors/authors.png"
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
- Monitoring
- Automated Deployment

The project took place over the course of 2 months with the premise of migrating all infrastrucatue needed to Azure, re-creation of a web portal, and enabling best practices for Automated Deployment and Infrastructure as code.  There was also a need to monitor usage patterns and quotas to make sure students were not manually standing up significant hardware that would ultimately be charged back to the University.  The hack team was composed of members from both Microsoft and the University and included:

- Major US Research University – Professor
- Major US Research University - Azure Project Lead and Sr TA
- Major US Research University – Many Teacher Assstants (TA) [Masters and Doctoral students]
- Dan Stolts – Senior Technical Evangelist, Microsoft, [@itproguru](https://twitter.com/itproguru) 
- Ian Philpot – Senior Technical Evangelist, Microsoft, [@tripdubroot](https://twitter.com/tripdubroot)
- Heather Shapiro – Technical Evangelist, Microsoft, [@microheather](https://twitter.com/microheather)
- Jessica Deen – Technical Evangelist, Microsoft, [@jldeen](https://twitter.com/jldeen)

## Customer profile ##

This Major US Research University is a world class university that is known for there leading edge stance on utilization of technology. They are a Premier Technology School in the world.  Top 5 overwall university in the world.
The Institute is an independent, coeducational, privately endowed university, organized into five Schools (architecture and planning; engineering; humanities, arts, and social sciences; management; and science). It has some 1,000 faculty members, more than 11,000 undergraduate and graduate students and more than 130,000 living alumni. They would, for now, prefer to remain annonymous so this document will refer to this University as simply "The University". The University provides its students with a platform to manage their infrastructure, submit homework, collaborate in teams, collaborate with professors. It gives students a single command to run to login to their automatically generated hardware infrastructure, provides students the capability to stand up additional infrastructure so they can thuroughly evaluate the performance of the software they create on different classes of machines and even clusters of servers. A large (6 or more) Teacher Assistants (TA) staff helps students as needed so they are also automatically granted access rights to the machines the students use. These TA's manage many aspects of the class including grading all homework, making sure the students are fully prepared to start class on day 1 with no technical surprises. They also manage the backend infrastructure that are used for submitting homework and exams. 

## Customer testimony ##



There were many aspects of this project that gave The University tremendous value.  Some of them included: 
  - Azure Active Directory integration with their organization account
  - Ability for Students to add additional multi-core machines and even clusters of machines for testing
  - 
<iframe src="https://channel9.msdn.com/Series/Customer-Solutions-Workshops/How-Azure-Web-Apps-and-DevOps-help-Roomsy-make-changes-faster-with-lower-risk/player" width="960" height="540" allowFullScreen frameBorder="0"></iframe>


## Architecture overview ##

// Currently Roomsy operates the [http://pagodabox.io/](http://pagodabox.io/) site in a cloud solution for hosting LAMP applications.

// Roomsy’s solution contains three PHP applications and two MySQL databases that are located on the same server. There are also tasks that run once every 15 minutes. The task has to invoke PHP pages in order to invoke some sync mechanisms with external providers like Booking.com or Expedia. The pages are not secured. 

// The list of the applications:

// - Channel Manager (cm.roomsy.com) + two tasks (every 15 minutes)
// - Roomsy Property Management System/API (api.roomsy.com, pms.roomsy.com + two tasks (hourly and daily)
// - Roomsy Web Site CMS (pages.roomsy.com)

// The applications use PHP 7.0, CodeIgniter 3.1 PHP framework, and ImageMagic extension with a MySQL back end.

// MySQL connection strings (credentials) are stored in the PHP environment file.
// MySQL databases are 800 MB only and they are growing slowly. 
// It’s possible to stop the applications for 10-30 minutes in order to update connection strings and finish migration tasks.

// The Roomsy domain is configured outside pagodabox.io using a third-party domain registrant. Here are the configuration details:

// ![Configuration details]( {{ site.baseurl }}/images/roomsy01.png)

// The pagodabox.io cloud doesn’t support CName for Custom Domain Names, so in order to configure the domain, you have to provide A records only.
 
## Problem statement ##

Students need access to High Performance computing for performance benchmarking in the classroom setting.  Due to the nature of the projects and benchmarking in class, these machines and access to other compute resources the students need it is cost effective to run them in the cloud so they can be turned off when not in use.  MIT currently leverages Azure for this purpose.  It is a manual process with each new class to break down the class environment and rebuild for the new class.  MIT needs to significantly streamline and automate this process.  They also have an Azure grant from Microsoft that they would like to leverage for this purpose. Customer also interested in creating a repeatable process for other classes within MIT and other classes in other institutions.

![Creating the value stream map]( {{ site.baseurl }}/images/ValueStreamMapping.jpg)
// While Dev and Staging environments did exist, they were not utilized in the current process.

// The process can be described in two steps:

// - Write code.
// - Copy code to production servers.
// While this seems to work today, this approach means there is no easy way to back out if a change breaks the production environment. There is no easy way to test new features without impacting the production environment and existing customers. And no way to ensure that availability is maintained since the entire solution currently runs on a single virtual machine.

## Project objectives ##

From their github repository,  perform pull request, create “Deploy to Azure”
Create ARM templates to deploy machines to azure
(Create CLI scripts that will run inside the virtual machines that are being deployed.
Copy CLI scripts to deployed VMs  
Modify existing python script to point to Azure accounts (instead of AWS)
Create High Performance Cluster of VMs that students will use for performance testing.    
Create CLI script to launch SSH session to High Performance cluster from student VM
Post to github for them to merge into master
Student authentication should be tied to MIT authentication.  MIT to assist with this part of the project.   They have experience having done it on AWS already. 

### Infrastructure as Code ###
For this project we actually provided many different ways to accomplish the same task.  ajslkdjflasjdflajsdflkjasdlfjl
- Configure Azure Active Directory
- Create Network
- Python Website
- Azure CLI (with JSON templates)
- Bash and Azure CLI (without JSON templates)
- PowerShell

### Classroom Deployment ###

### Azure Active Directory ###
Certain SDKs require the user to have an Active Directory account created on their Azure subscription. 

In order to set this up, users will need to walk through the following steps:
- Login to http://manage.windowsazure.com
- Click the button for active directory and select the Default Directory

![Active Directory](/images/activeDirectory/Step1.png)

- Click Users

![Users](/images/activeDirectory/Step2.png)

- Click “Add User” at the bottom

![Add User](/images/activeDirectory/Step3.png)
- Create a new user in your organization
 -	Give the user Global Admin rights
 ![Global admin rights](/images/activeDirectory/SetGlobalAdmin.png)
 - Select Create
 - Copy the password for your new user
- Go to settings 
 - Click the Administrator Tab 
 
![Settings](/images/activeDirectory/Settings.png)
- Select Add at the bottom and enter the new email address that you just created
 -	Select the subscription you want them to be added to
 
![addAdmin](/images/activeDirectory/addAdmin.png) 
- Log out of the Azure portal and relogin with your new Active Directory email
- Change your password
- Go to settings 
- Write down your subscription id

![SubscriptionID](/images/activeDirectory/SubscriptionID.png) 

### Virtual Network ###

In order to establish connections between student machines and the private and public shares as well as to allow the students to collaborate or share their machine with other students or TA's we created virtual machines on the same network which we created in scripts as seen in the image which shows the Linux Bash with Azure CLI version of the script.
 
![Share Same Network](/images/classroom10.png)

Creating the network is done prior to creation of any virtual machines. Of course, it’s possible to reconfigure any existing virtual network but it requires PowerShell knowledge or access to the old portal. So, prior to creating any virtual machines, we will create the network, subnet and network security group.  Finally as we deploy virtual machines we will creat the network interface cards used for the machine. Within the portal we can see graphically what was created. 

![Networking tab](/images/classroom11.png)

More details about virtual networks are available [here](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-vnet-arm-cli). Notice also that in this article there is a dropdown box to see how to do this on many different platforms.

Note that it requires about several minutes to configure a virtual network. **Don’t create any virtual machines before the virtual network is done.**

Once the virtual network is created, it’s possible to create a virtual machine. In this step you can specify an already existing virtual network:

![Creation of virtual machine](/images/classroom12.png)

Once the virtual machine is created, it’s possible to connect to the virtual machine with either Remote Desktop Client or SSH depending on the OS. This is possible because when we created the network security group we enable ports 22 and 3389 (RDP):

![Modify network security group settings](/images/classroom13.png)

By adding new inbound rules, it’s possible to specify any custom port or select a service from the list. (SSH then RDP was selected in our case.)

Once the port is open, it’s possible to connect the virtual machine using an IP address. Most of the machines we created were Linux so our tool of choice for connecting was [PuTTY]( http://www.putty.org/). 


### Azure Command Line (Azure-Cli) using JSON Templates ###

The Azure-CLI provides a cross-platform command line interface for developers and IT administrators to develop, deploy and manage Microsoft Azure applications. The Azure Classroom project provides a series of scripts based on the Azure-CLI, written in Bash, that will help you create virtual machine images and deploy them for use by students. These scripts should be accessible to users on both Mac OSX and various Linux flavors like Ubuntu or Fedora.

The scripts assume you’ve logged into the Azure-CLI and selected the subscription you want to target. They provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

Finally, a script the students will run is provided. This script pulls the gold image from the share location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM.

![Azure-CLI](/images/classroom_azure-cli_screenshot.png)

### Azure SDK for Python ###

The [Azure SDK for Python](http://azure-sdk-for-python.readthedocs.io/en/latest/) is a set of libraries which allow you to work on Azure for management, runtime or data needs. The Azure Classroom project provides a series of scripts using the Azure SDK for Python, that will help teachers and students create virtual machine images and deploy them for use by the students. These scripts will require that the user has Python installed on their computer, which can be downloaded from the [Python site](https://www.python.org/downloads/). There are Yalso several python libraries that are necesssary for the scripts to run but the scripts will handle checking for them and installing them if they are not found.

This SDK requires users to have an Azure AD Account set up. If you have not set one up yet, please see the [Azure Active Directory Section](#azure-active-directory).

####Run the Python scripts####

In order to run the scripts,you can use any IDE of your choice. For this example, we use the terminal. After downloading the scripts, you will need to cd into the proper folder, and run "python *script name*".

![Terminal](/images/python/commandPrompt.png)

The scripts will ask for your Azure credentials from the new Active Directory account that was just created. After you do this once, it will create a file for the user with the credentials so that the user does not have to keep entering their information in.

![Login](/images/python/login.PNG)

Similarly to the Azure CLI scripts, the python scripts provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

Finally, a script the students will run is provided. This script pulls the gold image from the share location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM.
### Bash and Azure CLI (without JSON templates)###
 Dan Stolts to provide later today 12/7

### PowerShell ###
For the PowerShell Scripts, there are 4 main scripts to build the lab and execute the deployment.

- login.ps1
Logs the user into both Azure CLI and Azure PowerShell.
![Using login.ps1](/images/powershell/classroom-ps-09-login_example.png)

- createbasevm.ps1
Uses Azure CLI to quickly create a Linux vm using passwordless authentication. The pub/private key pair is provided for convenience in the repo. Upon successful completion, the SSH connection string and deprovision command will also be pushed out to the console for the end user to use. 

![Using createbasevm.ps1](/images/powershell/classroom-ps-03-createbasevm_example1.png)
![Using createbasevm.ps1](/images/powershell/classroom-ps-04-createbasevm_example2.png)

- captureimage.ps1
Uses positional parameters to capture the resource group name and vm name in plain text when executing the PS script. The script will then capture the vm created using the previous createbasevm.ps1 script and copy the image vhd to a public storage account. After the copy completes, an Image URI is printed to the output of the screen for the end user to use with the following script.

![Using captureimage.ps1](/images/powershell/classroom-ps-01-captureimage_example1.png)
![Using captureimage.ps1](/images/powershell/classroom-ps-02-captureimage_example2.png)

- deployVM.ps1
Uses positional parameters to capture a NEW resource group name and Image URI from the 3rd script in plain text when executing the PS script. The script will then copy the VHD from the public storage account to the user's local storage account in their subscription. From there, the script will use the image to complete the deployment using the associated JSON template files, which can be found in the templates folder.

![Using deployVM.ps1](/images/powershell/classroom-ps-07-deployVM_example1.png)
![Using deployVM.ps1](/images/powershell/classroom-ps-08-deployVM_example2.png)

- deployVM.ps1 creates a Custom Storage Account Parameters file as seen below:

![Using CustStorageAcct.parameters.json](/images/powershell/classroom-ps-10-CustStorageAcct.parameters_example.png)

- deployVM.ps1 creates a Custom Gold VM Parameters file as seen below:

![Using CustomGoldVM.Parameters.json](/images/powershell/classroom-ps-05-CustGoldVM.parameters_example.png)

## General lessons ##

// Some key points to consider:

// - MySQL migration requires some knowledge of operations rather than development. It’s important to understand how to increase performance using RAID and how to use data disks to move database files there.
// - Thanks to Azure Virtual Network and Point to Site settings (and a Virtual Gateway) there, it’s possible to use Azure Web Apps and virtual machines in the same network to hide virtual machines disabling public IP addresses. It’s really useful in the case of databases.
// - It’s important to divide the migration process into several independent steps due to delays in domain records update. When migrating from third-party services, it’s not always possible to use CName. Therefore, it’s not always possible to use Traffic Manager and migration to production can be challenging.
// - It’s important to understand the sequence of steps during migration. For example, it’s better to create a Virtual Network using the Azure Web Apps interface than the virtual machine interface. That way, it’s not necessary to reconfigure the network from Site to Site to Point to Site.
// - Automated testing needs to always be a top priority, from unit tests to integration and load tests. Being confident in the quality of the code should be a prerequisite in order to release it.
// - Automation of the deployment for the development, testing, and production environments provides certitude that standards are maintained and that each environment is true to design and will lower failure risks.

## Conclusion ##

// We could use both infrastructure as a service (IaaS) and platform as a service (PaaS) approaches to guarantee the best result. Migration to Azure Web Apps is not challenging at all due to PHP 7 support and ability to use the staging environment that is integrated with GitHub. Creating the right virtual machine for MySQL is a little tricky but thanks to the generalization process we could build an image with a proper setup. So, it’s really easy to redeploy the virtual machine.

// The value stream mapping portion of the hack helped Roomsy see the big picture and understand where automation, proper processes, and DevOps practices can mitigate risks and allow for growth.

// A lot of very interesting ideas on how to improve the process were discussed during this Hackfest, some more doable than others. Most importantly, though, Roomsy realized the value of continuously improving and is committed and willing to put a lot of effort into this.
