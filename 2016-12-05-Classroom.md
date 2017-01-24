---
layout: post
title:  "How Azure and DevOps Enabled a Major US Research University to Deploy Backend and Student Machines for Class"
author: "Dan Stolts, Heather Shapiro, Ian Philpot, Jessica Deen"
author-link: "#"
#author-image: "(/images/2016-12-05-classroom/authors/authors.png"
date:   2016-12-05
categories: DevOps
color: "blue"
#image: "images/2016-12-05-classroom/imagename.png" #should be ~350px tall
excerpt: A Major US Research University partnered with Microsoft to learn how Azure infrastructure, a Web App and DevOps best practices could better address their need to quickly, easily and consistently onboard classroom and student infrastructure. This included: backend servers, storage and networking as well as student VMs, organizational authentication, private and public shares for students to use to submit homework or collaborate on teams. Read about the solution and how it was implemented. 
language: English
verticals: [Business to Business]
---

A Major US Research University partnered with Microsoft to learn how Azure infrastructure, a Web App and DevOps best practices could better address their need to quickly, easily and consistently onboard classroom and student infrastructure. This included: backend servers, storage and networking as well as student VMs, organizational authentication, private and public shares for students to use to submit homework or collaborate on teams. This class could have more than 400 students each term so automation was paramount on the needs list. The proof of concept (PoC) project made use of the following services and practices:

- Azure AD Integration
- Azure Blob Storage
- Infrastructure as Code
- Monitoring
- Automated Deployment

The project took place over the course of 2 months with the premise of migrating all infrastructure needed to Azure, re-creation of a web portal, and enabling best practices for Automated Deployment and Infrastructure as code.  There was also a need to monitor usage patterns and quotas to make sure students were not manually standing up significant hardware that would ultimately be charged back to the University.  The hack team was composed of members from both Microsoft and the University and included:

- Major US University – Professor - No dev role
- Major US University - Azure Project Lead and Sr TA - Development Partner/System Architect
- Major US University – Many Teacher Assistants (TA) [Masters and Doctoral students] - Documentation and student support
- Dan Stolts – Senior Technical Evangelist, Microsoft, [@itproguru](https://twitter.com/itproguru) 
- Ian Philpot – Senior Technical Evangelist, Microsoft, [@tripdubroot](https://twitter.com/tripdubroot)
- Heather Shapiro – Technical Evangelist, Microsoft, [@microheather](https://twitter.com/microheather)
- Jessica Deen – Technical Evangelist, Microsoft, [@jldeen](https://twitter.com/jldeen)

All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)

![Azure_Classroom on Github](/images/2016-12-05-classroom/classroom99-siteimage.png)

## Customer profile ##
This Major US University is a world-class university that is known for their leading-edge stance on the utilization of technology. The University is regularly regarded as a top 5 overall university worldwide. The Institute is an independent, coeducational, privately endowed university, organized into five Schools (architecture and planning; engineering; humanities, arts, and social sciences; management; and science). It has some 1,000 faculty members, more than 11,000 undergraduate and graduate students and more than 130,000 living alumni. They would, for now, prefer to remain anonymous so this document will refer to this University as simply "The University". The University provides its students with a platform to manage their infrastructure, submit homework, collaborate in teams, collaborate with professors. It gives students a single command to run to log in to their automatically generated hardware infrastructure, provides students the capability to stand up the additional infrastructure so they can thoroughly evaluate the performance of the software they create on different classes of machines and even clusters of servers. A large (6 or more) Teacher Assistants (TA) staff helps students as needed so they are also automatically granted access rights to the machines the students use. These TA's manage many aspects of the class including grading all homework, making sure the students are fully prepared to start class on day 1 with no technical surprises. They also manage the backend infrastructure that is used for submitting homework and exams. 

## Customer testimony ##
Direct Quotes from TA Tim K.
  - Last year we had 60 students; this year we were shocked that we had 120 signed up.  We to significantly scale this class. Given this large class size and the tremendous computational needs for this class, we had to look at the cloud for scale. Azure offered us the services we needed to alleviate this hurdle."
  - "Microsoft was able to offer some technical manpower to help set up the class in Azure."
  - "This assistance allowed us to get going on Azure very quickly.  It also helped with moral; it was reassuring to us that Microsoft was willing to help us solve challenges that might arise."
  - "After we set up everything the student experience was completely seamless."
  - "We were able to link credentials to the universities.EDU credentials so from a student perspective, they were able to log in exactly the same way as they logged into any other learning portal. The experience was completely seamless."
  - "We made it extremely easy and automatic to create, launch and initialize their VM for a perfect deployment.  They (students) simply had to run a script; if the students tried to do it manually there would have certainly been road bumps" 
  - "I was very pleased, and the rest of the core team was very pleased with how relatively painless this move to Azure ended up being. Of course, from the perspective of those that were not intimately involved, from the student’s perspective, it seemed like magic; everything just works. That is somewhat of an illusion because it was a bunch of work from Dan's team and the core team went into making that magic."
  - "When we started, we thought that we were just going to do a one to one substitution for what we already had, with just more scale.  What we found was there were many new opportunities we were able to take advantage of.  ... One of these was the ability to provide students with a multi-core instance to test their final exam; chess playing program. Students were given a budget to manage; they could then spin up additional cores 8 to test their program; some teams even launched multiple 8 core instances in parallel."
  - "We were able to monitor the entire usage of the class through a reasonable easy to use the portal. This allowed us to make sure no individual team was going nuts."
  - “We had overall a great experience using Microsoft Azure. We are very grateful for all the resources Microsoft provided.”

## Problem statement ##
Students need access to High-Performance computing for performance benchmarking in the classroom setting.  Due to the nature of the projects and benchmarking in class, these machines and access to other compute resources the students need it is cost effective to run them in the cloud so they can be turned off when not in use.  The University currently leverages AWS for this purpose.  It is a manual process with each new class to break down the class environment and rebuild for the new class.  The University needs to significantly streamline and automate this process.  They also have an Azure grant from Microsoft that they would like to leverage for this purpose. The customer is also interested in creating a repeatable process for other classes within The University and other classes in other institutions.

### Creating the Value Stream Map

The value stream mapping portion of the project helped The University see the big picture and understand where automation, proper processes, and DevOps practices can improve processes, expand capabilities, decrease setup time, simplify standing up a teaching environment and the value of monitoring the students and the process.

This process identified that the classroom environment is very different from a traditional enterprise or small company environment.  For this project, we were working with grad students as the workers (not professional developers). The programs were revised but they were not deployed in a typical deployment fashion. We discussed some ideas of how we could integrate full CI/CD but due to the very tight timeline we had for this project (before class starts) we had to limit the scope to automating delivery through scripts that can later be used to expand into CI/CD. To account for these changes we focused most of our efforts on designing Infrastructure as Code that would be the "Application" that they are deploying.   

Value Stream Maps (VSM) are a great vehicle to understand an existing workflow and to decide what areas to focus on for improvement. The diagram below is an example classroom development environment. The student VM is a "jump box" used for development. The student submits a Job message to the Job Cluster. The job cluster runs various tests and the student's grade gets calculated based on run time.  The report/grade is put in a private share for that student. You will notice the times to perform these various processes are extensive.  Weeks to build out the infrastructure and docs for each class.  Then the hard part is for students.  Students often needed to start setting up their environment before class started because for many it would take many days.  Some did not even get it done by Day 5 which was the day that the first homework assignment was due.  This caused the students to be late in submitting their homework.  For students that did not engage until day one of class, or enrolled late, they were in bad shape.  Most if not all of these students needed 1:1 TA support to get their systems and environment working correctly.  We expected to eliminate most of these delays which were caused by manual processes and confusion.  We expected development to take 3-4 weeks and student onboarding to take a day.  The resulting code took more than 6 weeks to develop on the calendar; 4 weeks engineer time; and less than a day to onboard the students.  Going over budget on the time calendar was mostly due to scope changes going through the project. Example, changing ARM Templates to Azure CLI.

The staff scheduled a "lab" to onboard students on the Saturday before class for students to get their environment set up with Microsoft and TA's in the room to assist as needed.  We had a couple changes that we had to make on the fly, redeployed the code mods a few times but get the entire class of over 100 students done in one day.  Most students were done in less than an hour.  The lab was scheduled in 4 different rooms and at 3 different time slots of 4 hours so we could accommodate all the students.  Approximately 90% were successful on their own with no TA interaction with just a URL on the board for where to go for the onboarding instructions.  The other 10% were fixed through tweaks (check for scenarios and accommodate) to the onboarding script, redeploying it to production and having those students try again [pseudo CI/CD]. Other than these few tweaks, Microsoft involvement was not needed. Clearly, this could all be done by staff moving forward. All students that showed up for the setup lab had their entire lab set up, logged into VMs, homework submission and running a test script on their VM before they left (1-2 hours each).  This far surpassed our goal of onboarding students with one day of student effort. It also almost completely eliminated the stress of helping students onboard. Most importantly the process was in place to repeat for future classes with little or no effort. 

During VSM we determined shared storage was going to be a requirement.  Students needed a way to send private work to the staff where other students could not see or otherwise gain access.  There was also a need to have students share files with other students.  This would allow for team collaboration.  This structure would need to be one of the first things we set up in order to accommodate connection from all other elements of the infrastructure. By having a separate script to define storage we could very easily isolate that component and build additional drives that could easily be mounted by students if it becomes needed during class. 

The value stream map helped identify opportunities for automating current manual processes.  It allowed the team to visualize scenarios that could improve the deliverables, streamline existing process and even eliminate processes that could be fully automated.  Examples of this include: authenticating using .EDU credentials, eliminating the need for students to manually sign-up for a cloud account and monitoring and tracking usage by the student. It showed how full CI/CD, automated testing and even automated destruction could greatly decrease manual processes while eliminating errors. Prior to the value stream map, these capabilities were not even in the thought process. Additionally, the value stream map provided additional areas of improvement that can be incorporated as changes made for future classes.

![Creating the value stream map](\images\2016-12-05-classroom\Azure_Classroom_VSM.jpg)

There were many manual processes that were identified for future work by the customer.  There were also a couple areas where heroics were identified.  In these cases, it was determined that others needed to be trained to take on some or all of those tasks at least for backup.  The heroics identified mostly revolved around one person that will only be in the program for a couple more years so it is important that this training starts now.  Documentation would also include ramping future TA's and likely even include videos to help streamline the onramp for TA's to understand what is going on behind the covers of the automation.  Much automation in particular where CI could play an important role will be tackled later. Staff expectation is they will continue to grow and add additional capabilities in future classroom deployments.

All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)

For this project, we identified many DevOps practices that can be added to the project.  For this project, Phase I, we incorporated Infrastructure as Code, Automated Deployment, and Monitoring. Once we handed off the project to the customer, they immediately added single sign-on capabilities so students would not have to sign into Azure.  This was simple because we already had all the scripts to do the work using Bash so all that was needed was automatically lay down a certificate on each of the VMs so the VMs the students were using could auto-authenticate to other systems that were deployed and to Azure Active Directory. After this class, they plan on including automated testing and continuing to improve the processes we established in this project.  Full CI/CD is the next big challenge.   

## Project objectives ##

The original goal of the project, after completing the value stream mapping, was to create a GitHub repository that students and teachers could pull from to deploy Virtual Machines to Azure to take advantage of DevOps practices by simplifying and automating everything while splitting the tasks out to standalone small tasks that could easily be run in its own environment. The University found that 100% of this could be automated so the TA could simply email the students a link to login to the web app, log in with their own organizational credentials, they could then automatically login to their machine using certificate based authentication.  The students were also being given a bash script (.sh) file in their standard working classroom folder that they could run to log into their Azure VM at any time.  They are also very likely to add additional capabilities before the end of the class including Automated Destruction. 

The various scripts would include: 
- Create ARM templates to deploy machines to azure
- Create CLI scripts that will run on the virtual machines that are being deployed.
- Copy CLI scripts to deployed VMs  
- Modify existing python script to point to Azure accounts (instead of AWS)
- Create scalable High-Performance Cluster of VMs that students will use for performance testing and submit homework.    
- Create CLI script to launch SSH session to High-Performance cluster from student VM
- Student authentication should be tied to organization authentication including Azure Active Directory.

## Infrastructure as Code ###
For this project, we provided many ways to accomplish the same task. This was a requirement because the primary TA is graduating soon and he wanted to set up his predecessor for success.  It also gives the advantage of making the different code available for students to use in their platform or language of choice. We also went in with the understanding that there were relationships between this class and other similar classes in other universities. The University wanted to add additional technology (PowerShell) to accommodate these other schools. The current TA that is running the program for this class preferred Python.  He did not know Azure CLI so he wanted us to write everything in Bash so he could very easily convert it to Python.
 The fundamental deployments that were required included: 

- Configure Azure Active Directory
- Create Network
- Create VM's and other related infrastructure in multiple environments
  - Python (with JSON templates)
  - Azure CLI (with JSON templates)
  - Bash and Azure CLI (without JSON templates)
  - PowerShell

As you go through the description of the technologies, please remember, it is not a common practice to do the same thing with multiple languages but this was a special case. It was just important to service the broader community as it was to service the immediate needs of the staff in this class. A huge upside of this approach is it can be leveraged by The University and their partner classes but also just about any classroom environment.  This could include any university, smaller school, training facilities or even businesses that perform internal or external training.

Infrastructure as the code was the code we were deploying and the processes that leveraged the DevOps practices.  We chose to organize in this fashion to streamline the development process by creating the things that were needed in the priority they were needed. The first components could be created first so testing could be done while still writing other parts of the program. Staff did most of the testing so it was also a great way to optimize the various roles participating in the process. Compartmentalization of the code also played a key role in moving the project forward quickly.  As an example, we built the underlying network and storage first. Then the capture image step (which could be tested alone manually). Then we built the VM scripts to deploy the student VMs which would leverage the captured image.  Each of these could be thoroughly tested while we were building out the homework submission servers which were not needed until the last day of week one.  We did end up getting all of it ready at least a week before class started but having the extra testing time by modules made staff very comfortable with the entire process.  Had we not done it this way it was apparent the staff might get nervous and roll back to the process they used the last term.  It was a painful process but there were no questions of it working.  By the time we got to the drop-dead date for them to start working the manual process, most of the infrastructure was setup, we had authentication working (no single sign-on yet) and the queue to process homework was working. These were the parts that were perceived to be the most challenging and was enough evidence that it was going to work as specified. 

All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)

When you look at the code, you may notice that there is not much error checking.  For the very limited time we had before class starts, the staff opted to leave out the error checking to maximize development cycles to hit the very tight timeline.  They will go back after this class and add checks and additional logic as needed to minimize crashes and improve understanding of error conditions if they should happen. 

### Azure Active Directory ###
Certain SDKs require the user to have an Active Directory account created on their Azure subscription. The University is already on Office365 for all staff and students.  They already have this Azure Active Directory configured to allow everyone to log in with organization (.edu) credentials. For organizations that do not already have this configured and running, it is very easy to setup using Azure Active Directory.  An AD account is also important for the customer as it provides the students with a single sign-on (SSO) organizational account. This allows them to access all applications within the Active Directory Tenant with the same credentials. 
For a step by step guide on how to set up an Azure Active Directory Account, please use this [tutorial](http://microheather.com/setting-up-azure-ad-to-use-with-azure-sdks/).

### Virtual Network ###

To establish connections between student machines and the private and public shares as well as to allow the students to collaborate or share their machine with other students or TA's we created virtual machines on the same network. We created this in scripts as seen in the image below which shows the Linux Bash with Azure CLI version of the script.  We wanted to have the networking available for each language. This would allow staff to be able to use the scripts to setup team and other environments that might be on different networks. Providing this made the scripts easy to follow and reproduce.  
 
![Share Same Network](/images/2016-12-05-classroom/classroom10-networking.png)

Creating the network is done prior to the creation of any virtual machines. Of course, it’s possible to reconfigure any existing virtual network but it requires PowerShell knowledge or access to the old portal.  This is of course not an issue if using JSON as everything automatically happens in the right sequence.  Because we wanted to provide the use case of standing up a complete environment with each VM Deployment script, we opted to just help you understand the consequences of doing it the long way (without JSON). Prior to creating any virtual machines, we will create the network, subnet and network security group.  Finally, as we deploy virtual machines we will create the network interface cards used for the machine. Within the portal, we can see graphically what was created.  The sequence is important to eliminate the challenge of creating scripts to do the network association to the VM. 

More details about virtual networks are available [here](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-vnet-arm-cli). Notice also that in this article there is a drop-down box to see how to do this on many different platforms.

Note that it requires a few minutes to configure a virtual network. **Don’t create any virtual machines before the virtual network is done.**

After the virtual network is complete, the next step is to create the Network Security Group (NSG). The NSG offers to route with port redirection, port enables, port disables, etc. Think of this as your firewall configuration for the network.  The NSG can be connected to the Subnet of the network, or any of the network interface cards attached to the network. This can be done using any of the languages we covered in this project and more.  The following image shows what it looks like in PowerShell.

![Share Same Network](/images/2016-12-05-classroom/classroom11-nsg.png)

Notice the first step is to create the new Network Security Group.  Then, you can add "rules" to the network security group.  For this project, we opened (or exposed) port 22 and port 3389.  Even the Linux student machines may opt to install desktop and xRDP so we wanted it to just work. The same is true for SSH on the Windows machines.  After creating the ports, we then must link the NSG to the subnet or NIC to enable them.

Once the virtual machine is created, it’s possible to connect to the virtual machine with either Remote Desktop Client or SSH depending on the OS or student preference.  By default, for this project, we are only using SSH on Linux and RDP on Windows but you could easily change the default custom image to enable RDP or SSH on both platforms. 

Once the port is open and the machine is running, it’s possible to connect the virtual machine using the machine IP address or DNS name. Most of the machines we created were Linux so our tool of choice for connecting was [PuTTY]( http://www.putty.org/).


### Azure Command Line (Azure-Cli) using JSON Templates ###

The Azure-CLI provides a cross-platform command line interface for developers and IT administrators to develop, deploy and manage Microsoft Azure applications. The Azure Classroom project provides a series of scripts based on the Azure-CLI, written in Bash, that will help you create virtual machine images and deploy them for use by students. These scripts should be accessible to users on both Mac OSX and various Linux flavors like Ubuntu or Fedora.  We chose Bash and Azure-CLI because the student VM's are all Linux and the students and staff in this class are already Linux savvy.  We built much of script and processes leveraging JSON templates.  There were places where we had to do some dynamic changes which made the JSON very difficult to follow.  During code review, with the staff, they found the JSON very difficult to follow and were worried that it would take too much training to learn it for this class staff as well as future classes.  They asked if there was another way to achieve the result without using JSON.  Obviously, our answer was yes and we proceeded to rewrite the components that used JSON using raw Azure-CLI commands. This was much easier for the staff to read, understand and modify.  It was more of a development burden than we anticipated but it did not jeopardize our overall timeline so we made it happen. Since we already had much of it built, we opted to provide both solutions for the open source community.  In cases where no dynamic content was needed or expected to be needed we kept JSON in the code due to the additional time, it would take to change.  

The scripts assume you’ve logged into the Azure-CLI and selected the subscription you want to target. They provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

A script the students will run is provided. This script pulls the gold image from the shared location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM. The default deployment is using Bash and Azure-CLI but there are other links that can be used for classes that are not Linux heavy.
All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)


![Azure-CLI](/images/2016-12-05-classroom/classroom20-azure-cli_screenshot.png)

### Bash and Azure CLI (without JSON templates) ###
The TA that was working with us on this found working with JSON templates someone complex.  He asked us to provide a Bash version of the scripts that were a little more simplified; that did not use JSON files. This was easy as we just needed to set parameters and call the functions to create the components.  In the following image, you will see that we set a couple order command line parameters for the Resource Group Name and the Image URL.  If these parameters were not passed, we set a default. NOTE: the default would need to be supplied by using the output of the create base VM or capture image scripts. We also exported these values to environment variables so they could be easily reused by other scripts.  As articulated above, this was done due to the complexity of dynamic JSON and readability. 

![Bash Azure-CLI Storage UniqueID](/images/2016-12-05-classroom/classroom25-bash-create-storageaccountname.png)

One important concept to note is on storage.  The storage account name is used for the public DNS name of the storage account.  For this reason, when creating the storage account, we needed to have a unique id to minimize the likelihood of conflict with other public storage account names.  The University already has a 3 letter unique id which is stored in an environment variable of the currently logged in user.  When we created the storage, we leveraged this key but since it is only a max of three letters it was not long enough to be unique in all of Azure.  We created an algorithm to add an additional 12-character random string using characters "a-z" and "0-9" we added that to the end of the "athena_user" and saved the output to a variable to use in creating the storage account. This allowed us to use the variable to setup the storage and get an access key. We also saved the unique id out to an environment variable called AZURE_UNIQUE_ID for use in other scripts. 

![Bash Azure-CLI Storage UniqueID](/images/2016-12-05-classroom/classroom26-bash-createstorage-getaccesskey.png)
All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)

### Azure SDK for Python ###

The [Azure SDK for Python](http://azure-sdk-for-python.readthedocs.io/en/latest/) is a set of libraries which allow you to work on Azure for management, runtime or data needs. The Azure Classroom project provides a series of scripts using the Azure SDK for Python, that will help teachers and students create virtual machine images and deploy them for use by the students. These scripts will require that the user has Python installed on their computer, which can be downloaded from the [Python site](https://www.python.org/downloads/). There are also several python libraries that are necessary for the scripts to run but the scripts will handle checking for them and install them if they are not found.

Like the Azure CLI scripts, the python scripts provision a VM that is used as what we refer to as a gold image. This is the machine image that will be used for student machines. These images are then generalized and copied into a location that is accessible from other student subscriptions. 

Finally, a script the students will run is provided. This script pulls the gold image from the shared location into a new storage account in the student’s subscription. It then uses an ARM template that references the gold image to deploy the student VM.
####How to Run the Python scripts####

This SDK requires users to have an Azure AD Account set up. If you have not set one up yet, please see the [Azure Active Directory Section](#azure-active-directory).

To run the scripts, you can use any IDE of your choice. For this example, we use the terminal. After downloading the scripts, you will need to cd into the proper folder and run "python *script name*".

![Terminal](/images/2016-12-05-classroom/python/commandPrompt.png)

The scripts will ask for your Azure credentials from the new Active Directory account that was just created. After you do this once, it will create a file for the user with the credentials so that the user does not have to keep entering their information in.
![Login](/images/2016-12-05-classroom/python/login.PNG)
All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)


### PowerShell ###
For the PowerShell Scripts, there are 4 main scripts to build the lab and execute the deployment.
- login.ps1
Logs the user into both Azure CLI and Azure PowerShell.![Using login.ps1](/images/2016-12-05-classroom/classroom30-ps-login_example.png)


- createbasevm.ps1
Uses Azure CLI to quickly create a Linux VM using a certificate instead of password authentication. The pub/private key pair is provided for convenience in the repo. This is not the same key The University used. It is just a sample to make trying it easy. We recommend generating your own keys using a tool like [Azure Key Vault] (https://azure.microsoft.com/en-us/services/key-vault/). [PuTTY]( http://www.putty.org/) is an open source program that can be used to generate keys. Upon successful completion, the SSH connection string and the deprovisioning command will also be pushed out to the console for the end user to use.  

![Using createbasevm.ps1](/images/2016-12-05-classroom/classroom31-ps-createbasevm_example1.png)
![Using createbasevm.ps1](/images/2016-12-05-classroom/classroom32-ps-createbasevm_example2.png)

-- captureimage.ps1
Uses positional parameters to capture the resource group name and VM name in plain text when executing the PS script. The script will then capture the VM created using the previous createbasevm.ps1 script and copy the image VHD to a public storage account. After the copy completes, an Image URI is printed to the output of the screen for the end user to use with the following script.


![Using captureimage.ps1](/images/2016-12-05-classroom/classroom33-ps-captureimage_example2.png)

![Using captureimage.ps1](/images/2016-12-05-classroom/classroom34-ps-captureimage_example1.png)

- deployVM.ps1
Uses positional parameters to capture a NEW resource group name and Image URI from the 3rd script in plain text when executing the PS script. The script will then copy the VHD from the public storage account to the user's local storage account in their subscription. From there, the script will use the image to complete the deployment using the associated JSON template files, which can be found in the templates folder.

![Using deployVM.ps1](/images/2016-12-05-classroom/classroom37-ps-deployVM_example1.png)

![Using deployVM.ps1](/images/2016-12-05-classroom/classroom38-ps-deployVM_example2.png)

- deployVM.ps1 creates a Custom Storage Account Parameters file as seen below:

![Using CustStorageAcct.parameters.json](/images/2016-12-05-classroom/classroom36-ps-CustStorageAcct.parameters_example.png)

- deployVM.ps1 also creates a Custom Gold VM Parameters file as seen below:

![Using CustomGoldVM.Parameters.json](/images/2016-12-05-classroom/classroom35-ps-CustGoldVM.parameters_example.png)
All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)


## Automated Deployment, Testing, Monitoring, Automated Destruction, CI/CD ##
To deploy the many components of this application we used automated deployment and infrastructure as code. Together, this allowed us to spin up many servers, networks, storage accounts, as well as a customized image that was the base to deploy hundreds of student machines that could all talk to each other and authenticate using their standard .EDU credentials.  The various scripts that were created were set up as different components that can easily isolate and minimize risk as future mods are made.  As an example, capturing the image is separate from building the student machines.  Creating these small segments of code further moves the code to an agile and CI/CD compliant model. Currently, these scripts for deployment are manually triggered by the staff.  Once triggered, they automatically deploy all the hardware defined for that script.  This also allows the staff to easily loop through a list of student email addresses to build out machines and credentials for the student's machines regardless of the size of the class.  This class did not leverage this technology.  However, they expect this will be one of the first things they add for next class as it will cut 30 mins off the student onramp process. 

We wanted to setup automated testing but due to lack of time, we decided to simply start the process of identifying test criteria that we could then expand on later and add to what will eventually be the CI/CD pipeline.  The following is an example of some of those tasks. 

Test scenario for capturing and deploying master student image scripts
    1. Master to be captured VM Exists and has been customized… file placed on local disk
    2. Capture is called on that VM (using capture script)
    3. Same account… Create two VMs by calling deploy script twice
      a. Both should have same disks including test file 
      b. Script is not placing the file, it is in the original image

We need to add basic monitoring capabilities of the VMs.  We found this to be incredibly easy as the internal monitoring of Azure VMs gave TA's and Students all the information they needed.  All we had to do was enable it.

CI/CD, before this project, was not even considered.  Today, the staff can see how adding additional capabilities in the future can get to a place where Continuous Integration/Continuous Deployment are a reality.

An opportunity identified during the VSM was, in an education environment, we are completely wiping out all infrastructure, including student data and recreating it for the next class.  Any programs that the student created in class would be archived on their own GitHub account. The infrastructure had to be completely rebuilt for the new class accommodating permissions for the new users, ID's, roles, teams, etc.  There is no, tweaking the hardware, it is a wipe and replace every term. This greatly adds to the viability to having a complete DevOps experience to deprovision and delete all infrastructure. To accommodate and simplify this process, we used resource groups to build infrastructure and could very easily delete the resource group and all items in it. Adding a text file to identify the resource groups we are adding as a script was considered as an easy next step. This would allow the automation to only delete the resource groups that were created by the scripts.  This was not implemented yet simply due to time constraints and a potential gap where students or staff create additional RGs and they do not get deleted with the class.  Staff may create RGs that are classroom related which could be done with code and CI/CD in the future.  Then if they want to create an RG that is not deleted, provisions would have to be made. This will be an obstacle for another day.  


## General lessons ##
Some key learnings to consider from this process:
  - Each of the different scripts proved to provide different challenges, one example is authentication for each language had slight variances in authentication.
  - It is important to note that it takes times for each script to complete. Copying an image of the Virtual Machine can take several minutes to finish.
  - Important to understand the process of deprovisioning, generalizing, and capturing the image, otherwise you will not be able to copy the image to a new resource group or account.
  - To copy the "Gold Image", you need to make sure that the original image is public and not a premium_LRS. If it is private, you will not be able to copy the image through scripts.
  - You can test the JSON templates through PowerShell by logging into your Azure account and running `Test-AzureRmResourceGroupDeployment -ResourceGroupName <String> -TemplateFile <String> `
  - In some situations, it is required to get Azure Engineering team involved so they confirm limitations and take feedback for making the product better.
  - The TA’s in a class are great partners for helping with student onboarding.  6 TA’s means if or when there are a bunch of questions by students they can be spread among many people.
  - Primary tenants of Azure are speed and performance. They are critical on all high-performance workloads.  Usually, in business, this is exactly what customers want.  However, it is not well suited for a platform that needs limited variability in job runs.  Example. If you run a script for performance on time it could take 3 seconds.  Run the same script again it could run in 2.93 seconds. Run it a third time, and it could be another number in between.  The University expectation is if you run the same script multiple times you should get the same run time within hundreds of a second. When running on Azure you do not. This variability is a problem for any class where performance is evaluated.  This will include performance classes, OS classes, DB classes, ML classes, Analytics classes and many, more. The Azure Engineering team is looking for an offering or customization that can be made where The University can disable technologies like "Turbo" which causes this variability. The reason there is variability is to give maximum performance available on the hardware. To give the customer, the fastest possible speed for each workload Turbo is turned on and cannot be turned off. For most machines, including all high-performance machines, Turbo is enabled. When using Turbo if the host happens to be quiet, the workload will get a big boost of CPU cycles, if the host is busy, it could get no boost. The University would rather sacrifice that turbo boost speed to have little or no variability.
  - Scripts that do not use JSON can sometimes be easier for customers to read especially if there are dynamic changes to the JSON.

## Conclusion ##
The University sees the project outcomes being applying DevOps capabilities such as automated deployment, infrastructure as code and monitoring to deliver a fully automated solution to stand up a class of more than a hundred students, many teacher assistants as well as multiple professors. Leveraging VSM, the team identified and eliminated many wasted and manual steps. They found limitations to current process and opportunities for improvement. The team used this project to correct and add capabilities that could be leveraged immediately.  They wanted to deploy to Azure to inherently gain additional capabilities.  Many more opportunities were identified to continue improving in the future. The required expectation of being able to use different languages to support different options for the people that would in the future made it a bit more challenging.  However, the result and open nature of the code (GitHub MIT License) can be used by not only The University but any university and any classroom environment.  These scripts and processes can be used for one day or multiple day workshops, classes that last weeks, months or even years.  It can be used to setup any demo or teaching environment where simplicity of deployment and consistency of process are required.
All source code can be found on [github](http:/github.com/dstolts/Azure_Classroom)

## Resources ##
  - Azure Active Directory [tutorial](http://microheather.com/setting-up-azure-ad-to-use-with-azure-sdks/)
  - More details about [virtual networks](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-vnet-arm-cli). Notice there is a dropdown box to see how to do this on many platforms.
  - [PuTTY]( http://www.putty.org/)
  - [Azure SDK for Python](http://azure-sdk-for-python.readthedocs.io/en/latest/)
  - [Python site](https://www.python.org/downloads/)
  - [Azure Key Vault] (https://azure.microsoft.com/en-us/services/key-vault/)
  - Source Code on [github](http:/github.com/dstolts/Azure_Classroom) 