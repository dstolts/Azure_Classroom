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
excerpt: A Major US Research University US partnered with Microsoft to learn how Azure infrastructure, a Web App and DevOps best practices could better address their need to quickly, easily and consistently onboard classroom and student infrastructure. This included: backend servers, storage and networking as well as student VMs, organizational authentication, private and public shares for students to use to submit homework or collaborate on teams. Read about the solution and how it was implemented. 
language: English
verticals: [Business to Business]
---

A Major US Research University US partnered with Microsoft to learn how Azure infrastructure, a Web App and DevOps best practices could better address their need to quickly, easily and consistently onboard classroom and student infrastructure. This included: backend servers, storage and networking as well as student VMs, organizational authentication, private and public shares for students to use to submit homework or collaborate on teams. This class could have more than 400 students each term so automation was paramount on the needs list. The proof of concept (PoC) project made use of the following services and practices:

- Azure AD Integration
- Azure Blob Storage
- Infrastructure as Code
- Monitoring
- Automated Deployment

The project took place over the course of 2 months with the premise of migrating all infrastructure needed to Azure, re-creation of a web portal, and enabling best practices for Automated Deployment and Infrastructure as code.  There was also a need to monitor usage patterns and quotas to make sure students were not manually standing up significant hardware that would ultimately be charged back to the University.  The hack team was composed of members from both Microsoft and the University and included:

- Major US University – Professor
- Major US University - Azure Project Lead and Sr TA
- Major US University – Many Teacher Assistants (TA) [Masters and Doctoral students]
- Dan Stolts – Senior Technical Evangelist, Microsoft, [@itproguru](https://twitter.com/itproguru) 
- Ian Philpot – Senior Technical Evangelist, Microsoft, [@tripdubroot](https://twitter.com/tripdubroot)
- Heather Shapiro – Technical Evangelist, Microsoft, [@microheather](https://twitter.com/microheather)
- Jessica Deen – Technical Evangelist, Microsoft, [@jldeen](https://twitter.com/jldeen)

All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)

![Azure_Classroom on Github]({{ site.baseurl }}/images/classroom99-siteimage.png)

## Customer profile ##

This Major US University is a world class university that is known for their leading-edge stance on utilization of technology. They are a Premier Technology School in the world.  Top 5 overall university in the world.
The Institute is an independent, coeducational, privately endowed university, organized into five Schools (architecture and planning; engineering; humanities, arts, and social sciences; management; and science). It has some 1,000 faculty members, more than 11,000 undergraduate and graduate students and more than 130,000 living alumni. They would, for now, prefer to remain anonymous so this document will refer to this University as simply "The University". The University provides its students with a platform to manage their infrastructure, submit homework, collaborate in teams, collaborate with professors. It gives students a single command to run to login to their automatically generated hardware infrastructure, provides students the capability to stand up additional infrastructure so they can thoroughly evaluate the performance of the software they create on different classes of machines and even clusters of servers. A large (6 or more) Teacher Assistants (TA) staff helps students as needed so they are also automatically granted access rights to the machines the students use. These TA's manage many aspects of the class including grading all homework, making sure the students are fully prepared to start class on day 1 with no technical surprises. They also manage the backend infrastructure that are used for submitting homework and exams. 

## Customer testimony ##

There were many aspects of this project that gave The University tremendous value.  Some of them included: 
  - Azure Active Directory integration with their organization account
  - Ability for Students to add additional multi-core machines and even clusters of machines for testing
  - Ability to automate everything and provide a simple onramp for students
  - Ability to setup quotas for student and monitor how they are doing against their quotas
  - onramp a new class in hours instead of weeks

## Problem statement ##

Students need access to High Performance computing for performance benchmarking in the classroom setting.  Due to the nature of the projects and benchmarking in class, these machines and access to other compute resources the students need it is cost effective to run them in the cloud so they can be turned off when not in use.  MIT currently leverages Azure for this purpose.  It is a manual process with each new class to break down the class environment and rebuild for the new class.  MIT needs to significantly streamline and automate this process.  They also have an Azure grant from Microsoft that they would like to leverage for this purpose. Customer also interested in creating a repeatable process for other classes within MIT and other classes in other institutions.

### Creating the Value Stream Map

The value stream mapping portion of the project helped The University see the big picture and understand where automation, proper processes, and DevOps practices can improve processes, expand capabilities, decrease setup time, simplify standing up a teaching environment and the value of monitoring the students and the process. 

Value Stream Maps are a great vehicle to understand an existing workflow and to decide what on what areas to focus improvement on. The diagram below is an example classroom development environment. The area inside the dashed box, "Build VMs", is the student environment. One machine is a "jump box" used for development, the other staging environment for building the application. The student submits a Job message to the Job Cluster. The job cluster runs various tests and the students grade gets calculated.

![Creating the value stream map]({{ site.baseurl }}/images/classroom00-valuestreammapping.jpg)


## Project objectives ##

The original goal for the project, after completing the value steam mapping, was to create a GitHub repository that students and teachers could pull from to deploy Virtual Machines to Azure to take advantage of DevOps practices by simplifying and automating everything while splitting the tasks out to standalone small tasks that could easily be run in its own environment. The University found that 100% of this could be automated so the TA could simply email the students a link to login to the web app, login with their own organizational credentials, they could then automatically login to their machine using certificate based authentication.  The students were also being given bash script (.sh) file in their standard working classroom folder that they could run to login to their Azure VM at any time. 

These scripts would: 
- Create ARM templates to deploy machines to azure
- Create CLI scripts that will run inside the virtual machines that are being deployed.
- Copy CLI scripts to deployed VMs  
- Modify existing python script to point to Azure accounts (instead of AWS)
- Create scalable High Performance Cluster of VMs that students will use for performance testing and submitting homework.    
- Create CLI script to launch SSH session to High Performance cluster from student VM
- Post to GitHub for them to merge into master
- Student authentication should be tied to organization authentication.

## Infrastructure as Code ###
For this project, we provided many ways to accomplish the same task. This was a requirement because the primary TA is graduating soon and he wanted to setup his predecessor for success.  It also gives the advantage of making different code available for students to use in their platform or language of choice.  The fundamental deployments that were required included: 

- Configure Azure Active Directory
- Create Network
- Create VM's and other related infrastructure in multiple environments
  - Python (with JSON templates)
  - Azure CLI (with JSON templates)
  - Bash and Azure CLI (without JSON templates)
  - PowerShell

### Azure Active Directory ###
Certain SDKs require the user to have an Active Directory account created on their Azure subscription. The University is already on Office365 for all staff and students.  They already have this Azure Active Directory configured to allow everyone to login with organization (.edu) credentials. For organizations that do not already have this setup and running it is very easy to setup using Azure Active Directory.  An AD account is also important for the customer as it provides the students with a single sign-on (SSO) organizational account. This allows them to access all applications within the Active Directory Tenant with the same credentials. 
For a step by step guide on how to set up an Azure Active Directory Account, please use this [tutorial](http://microheather.com/setting-up-azure-ad-to-use-with-azure-sdks/).

### Virtual Network ###

To establish connections between student machines and the private and public shares as well as to allow the students to collaborate or share their machine with other students or TA's we created virtual machines on the same network. We created this in scripts as seen in the image below which shows the Linux Bash with Azure CLI version of the script.
 
![Share Same Network]({{ site.baseurl }}/images/classroom10-networking.png)

Creating the network is done prior to creation of any virtual machines. Of course, it’s possible to reconfigure any existing virtual network but it requires PowerShell knowledge or access to the old portal. So, prior to creating any virtual machines, we will create the network, subnet and network security group.  Finally, as we deploy virtual machines we will create the network interface cards used for the machine. Within the portal we can see graphically what was created. 

More details about virtual networks are available [here](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-vnet-arm-cli). Notice also that in this article there is a dropdown box to see how to do this on many different platforms.

Note that it requires a few minutes to configure a virtual network. **Don’t create any virtual machines before the virtual network is done.**

After the virtual network is complete, the next step is to create the Network Security Group (NSG). The NSG offers routing with port redirection, port enable, port disable, etc. Think of this as your firewall configuration for the network.  The NSG can be connected to the Subnet of the network, or any of the network interface cards attached to the network. This can be done using any of the languages we covered in this project and more.  The following image shows what it looks like in PowerShell.

![Share Same Network]({{ site.baseurl }}/images/classroom11-nsg.png)

Notice the first step is to create the new Network Security Group.  Then, you can add "rules" to the network security group.  For this project, we opened (or exposed) port 22 and port 3389.  Even the Linux student machines may opt to install desktop and xRDP so we wanted it to just work. The same is true for SSH on the Windows machines.  After creating the ports, we then must link the NSG to the subnet or NIC to enable them.

Once the virtual machine is created, it’s possible to connect to the virtual machine with either Remote Desktop Client or SSH depending on the OS or student preference.  By default, for this project we are only using SSH on Linux and RDP on Windows but you could easily change the default custom image to enable RDP or SSH on both platforms. 

Once the port is open and the machine is running, it’s possible to connect the virtual machine using the machine IP address or DNS name. Most of the machines we created were Linux so our tool of choice for connecting was [PuTTY]( http://www.putty.org/).


### Azure Command Line (Azure-Cli) using JSON Templates ###

The Azure-CLI provides a cross-platform command line interface for developers and IT administrators to develop, deploy and manage Microsoft Azure applications. The Azure Classroom project provides a series of scripts based on the Azure-CLI, written in Bash, that will help you create virtual machine images and deploy them for use by students. These scripts should be accessible to users on both Mac OSX and various Linux flavors like Ubuntu or Fedora.

The scripts assume you’ve logged into the Azure-CLI and selected the subscription you want to target. They provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

Finally, a script the students will run is provided. This script pulls the gold image from the share location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM.

![Azure-CLI]({{ site.baseurl }}/images/classroom20-azure-cli_screenshot.png)

### Bash and Azure CLI (without JSON templates)###
The TA that was working with us on this found working with JSON templates someone complex.  He asked us to provide a Bash version of the scripts that were a little more simplified; that did not use JSON files. This was easy as we just needed to set parameters and call the functions to create the components.  In the following image you will see that we set a couple order command line paramaters for the Resource Group Name and the Image URL.  If these parameters were not passed, we set a default. NOTE: the default would need to be supplied by using the Output of the createbasevm or captureimage scripts. We also exported these values to environment variables so they could be easily reused by other scripts. 

![Bash Azure-CLI Storage UniqueID]({{ site.baseurl }}/images/classroom25-bash-create-storageaccountname.png)

One important concept to note is on storage.  The storage account name is used for the public DNS name of the storage account.  For this reason, when creating the storage account, we needed to have a uniqueid to minimize the likelihood of conflict with other public storage account names.  The University already has a 3 letter uniqueid which is stored in an environment variable of the currently logged in user.  When we created the storage, we leveraged this key but since it is only a max of three letters it was not long enough to be unique in all of Azure.  We created an algorithm to add an additional 12-character random string using characters "a-z" and "0-9" we added that to the end of the "athena_user" and saved the output to a variable to use in creating the storage account. This allowed us to use the variable to setup the storage and get an access key. We also saved the uniqueid out to an environment variable called AZURE_UNIQUE_ID for use in other scripts. 

![Bash Azure-CLI Storage UniqueID]({{ site.baseurl }}/images/classroom26-bash-createstorage-getaccesskey.png)

### Azure SDK for Python ###

The [Azure SDK for Python](http://azure-sdk-for-python.readthedocs.io/en/latest/) is a set of libraries which allow you to work on Azure for management, runtime or data needs. The Azure Classroom project provides a series of scripts using the Azure SDK for Python, that will help teachers and students create virtual machine images and deploy them for use by the students. These scripts will require that the user has Python installed on their computer, which can be downloaded from the [Python site](https://www.python.org/downloads/). There are also several python libraries that are necessary for the scripts to run but the scripts will handle checking for them and installing them if they are not found.

Like the Azure CLI scripts, the python scripts provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

Finally, a script the students will run is provided. This script pulls the gold image from the share location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM.
####How to Run the Python scripts####

This SDK requires users to have an Azure AD Account set up. If you have not set one up yet, please see the [Azure Active Directory Section](#azure-active-directory).

To run the scripts, you can use any IDE of your choice. For this example, we use the terminal. After downloading the scripts, you will need to cd into the proper folder, and run "python *script name*".

![Terminal]({{ site.baseurl }}/images/python/commandPrompt.png)

The scripts will ask for your Azure credentials from the new Active Directory account that was just created. After you do this once, it will create a file for the user with the credentials so that the user does not have to keep entering their information in.
![Login]({{ site.baseurl }}/images/python/login.PNG)


### PowerShell ###
For the PowerShell Scripts, there are 4 main scripts to build the lab and execute the deployment.
- login.ps1
Logs the user into both Azure CLI and Azure PowerShell.![Using login.ps1]({{ site.baseurl }}/images/classroom30-ps-login_example.png)


- createbasevm.ps1
Uses Azure CLI to quickly create a Linux vm using certificate instead of password authentication. The pub/private key pair is provided for convenience in the repo. This is not the same key The University used. It is just a sample to make trying it easy. We recommend generating your own keys using a tool like [Azure Key Vault] (https://azure.microsoft.com/en-us/services/key-vault/). [PuTTY]( http://www.putty.org/) is an open source program that can be used to generate keys. Upon successful completion, the SSH connection string and deprovisioning command will also be pushed out to the console for the end user to use.  

![Using createbasevm.ps1]({{ site.baseurl }}/images/classroom31-ps-createbasevm_example1.png)
![Using createbasevm.ps1]({{ site.baseurl }}/images/classroom32-ps-createbasevm_example2.png)

-- captureimage.ps1
Uses positional parameters to capture the resource group name and vm name in plain text when executing the PS script. The script will then capture the vm created using the previous createbasevm.ps1 script and copy the image vhd to a public storage account. After the copy completes, an Image URI is printed to the output of the screen for the end user to use with the following script.


![Using captureimage.ps1]({{ site.baseurl }}/images/classroom33-ps-captureimage_example2.png)

![Using captureimage.ps1]({{ site.baseurl }}/images/classroom34-ps-captureimage_example1.png)

- deployVM.ps1
Uses positional parameters to capture a NEW resource group name and Image URI from the 3rd script in plain text when executing the PS script. The script will then copy the VHD from the public storage account to the user's local storage account in their subscription. From there, the script will use the image to complete the deployment using the associated JSON template files, which can be found in the templates folder.

![Using deployVM.ps1]({{ site.baseurl }}/images/classroom37-ps-deployVM_example1.png)

![Using deployVM.ps1]({{ site.baseurl }}/images/classroom38-ps-deployVM_example2.png)

- deployVM.ps1 creates a Custom Storage Account Parameters file as seen below:

![Using CustStorageAcct.parameters.json]({{ site.baseurl }}/images/classroom36-ps-CustStorageAcct.parameters_example.png)

- deployVM.ps1 also creates a Custom Gold VM Parameters file as seen below:

![Using CustomGoldVM.Parameters.json]({{ site.baseurl }}/images/classroom35-ps-CustGoldVM.parameters_example.png)

## General lessons ##

Some key learnings to consider from this process:
  - Each of the different scripting languages proved different challenges and required different levels of authentication.
  - It is important to note that it takes times for each script to complete. Copying an image of the Virtual Machine can take several minutes to finish.
  - Important to understand the process of deprovisioning, generalizing, and capturing the image, otherwise you will not be able to copy the image to a new resource group or account.
  - To copy the "Gold Image", you need to make sure that the original image is public and not a premium_LRS. If it is private, you will not be able to copy the image through scripts.
  - You can test the JSON templates through PowerShell by logging into your Azure account and running `Test-AzureRmResourceGroupDeployment -ResourceGroupName <String> -TemplateFile <String> `
  - In some situations, it is required to get Azure Engineering team involved so they confirm limitations and take feedback for making the product better.
  - The TA’s in a class are great partners for helping with student onboarding.  6 TA’s means if or when there are a bunch of silly questions by students they can be spread among many people.
  - Azure is not well suited for a platform that needs limited variability in job runs.  E.g. If you run a script for performance on time it could take 3 seconds.  Run the same script again it could run in 2.8 seconds. Run it a third time, and it will be another number in between.  The University expectation is if you run the same script multiple times you should get the same run time within hundreds of a second. When running on Azure you do not. This variability is a problem for any class where performance is evaluated.  This will include performance classes, OS classes, DB classes, ML classes, Analytics classes and many, many more. The Azure Engineering team is looking for an offering or customization that can be made where The University can disable technologies like "Turbo" which causes this variability. The reason there is variability is to give maximum performance available on the hardware. In order to give the customer, the fastest possible speed for each and every workload Turbo is turned on for most class machines including all high-performance class machines which is what the University needs to use. When using Turbo if the host happens to be quiet, the workload will get a big boost of CPU cycles, if the host is busy, it could get no boost. The University would rather sacrifice that turbo boost speed to have little or no variability.
  - Scripts that do not use JSON can sometimes be easier for customers to read.

## Conclusion ##

We used many DevOps capabilities to deliver a fully automated solution to stand up a class of hundreds of students, many TA as well as multiple professors.  The required expectation of being able to use different languages to support different options of the people that would in the future be doing it made it a bit more challenging.  However, the result and open nature of the code can be used by not only any university but any classroom environment.  We see this being used for one day or multiple day workshops, classes that last weeks, months or even years.  It can be used to setup any demo or teaching environment where simplicity of deployment and consistency of process are required.
