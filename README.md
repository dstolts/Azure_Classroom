# Azure_Classroom
Scripted Deployment of Azure Resources for an Entire Classroom

We will leverage many different programming languages, scripting languages and technologies to give educators the tools they need to rapidly and repeatedly onboard an entire classroom of resources.  It will include server infrastructure as well as student VM environments.  All scripts will be well documented and access to commonly used variables will be provided at the top of the script for easy customization. Destination machines being deployed can be any VM that runs on Azure (Linux or Windows).  Over time, Azure_Classroom will be expanded to stand up other infrastructure as well such as machines for research, websites, docker containers, etc.

Scripted deployment is designed for deploying large classroom environments of hundreds or even thousands of students in a single class but it can also be used for smaller classrooms.

# Upcoming Technologies and scripts
Linux:
    1) Bash Script with Azure_CLI to make an "image" from an existing VM to use for classroom deployment
    2) Bash Script with Azure_Cli to create a VM based on a provided VM image to be used by each student for deploying their working environment without leveraging templates
    3) Bash Script with Azure_Cli to create a VM based on a provided VM image to be used by each student for deploying their working environment leveraging Templates JSON files
    
PowerShell: 
    1) With Azure_CLI to make an "image" from an existing VM to use for classroom deployment
    2) With Azure_Cli to create a VM based on a provided VM image (or standard) to be used by each student for deploying their working environment (no template)
    3) With Azure_Cli to create a VM based on a provided VM image (or standard) to be used by each student for deploying their working environment without leveraging templates
    3) Build out the number of VM environments needed for an entire clas to a single subscription 
    4) Build VM environments for a list of students provided which includes email address, names and subscriptionID to deploy all VMs needed and set security rights for each subscription provided by the list.  This also includes granting Professor and Teacher Assistant security rights to all subscriptions 
Python: 
    1) Script with Azure_Cli to create a VM based on a provided VM image to be used by each student for deploying their working environment
    2) Build out the number of VM environments needed for an entire class to a single subscription 
    3) Build VM environments for a list of students provided which includes email address, names and subscriptionID to deploy all VMs needed and set security rights for each subscription provided by the list.  This also includes granting Professor and Teacher Assistant security rights to all subscriptions 
        Deploy To Azure Button to run scripts as an Azure Function. Steamlined for high performance ... target, standup 1000 machine class in 20 mins.  Includes ability to use custom image (target single custom image deployment in less than 10 mins)
.NET
    1) Create a VM based on a provided VM image (or default) to be used by each student for deploying their working environment
    2) Build out the number of VM environments needed for an entire class to a single subscription 
    3) Build VM environments for a list of students provided which includes email address, names and subscriptionID to deploy all VMs needed and set security rights for each subscription provided by the list.  This also includes granting Professor and Teacher Assistant security rights to all subscriptions 
        Deploy To Azure Button to run scripts as an Azure Function. Steamlined for high performance ... target, standup 1000 machine class in 20 mins.  Includes ability to use custom image (target single custom image deployment in less than 10 mins)

# Many more to come    
  R Based VM to interactively run your R scripts
  R based Batch to run your R scripts

# If you would like to work on the buildout of this project, please contact Dan Stolts dstolts@microsoft.com

