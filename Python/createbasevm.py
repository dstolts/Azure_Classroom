
# coding: utf-8

# In[ ]:

##pip3 install --pre azure
##pip4 install msrest
##pip3 install msrestazure


# In[13]:

import json

from azure.common.credentials import UserPassCredentials

from azure.mgmt.resource import ResourceManagementClient

from azure.mgmt.storage import StorageManagementClient

from azure.storage import CloudStorageAccount
# from azure.mgmt.resource.resources.models import ContentSettings

from azure.mgmt.resource.resources.models import ResourceGroup

from azure.mgmt.resource.resources.models import Deployment

from azure.mgmt.resource.resources.models import DeploymentProperties

from azure.mgmt.resource.resources.models import DeploymentMode

from azure.mgmt.resource.resources.models import ParametersLink
from azure.mgmt.resource.resources.models import TemplateLink


# In[5]:

with open("az_config.json") as data_file:

    data = json.load(data_file)

    

def get_credentials(config_data):

    return UserPassCredentials(

        config_data["username"],

        config_data["password"],

    )

def get_subscription(config_data):
    return config_data["subscription_id"]


# In[8]:

credentials = get_credentials(data)
subscription_id = get_subscription(data)
print("Creds have been delivered from:", credentials.cred_store)


# In[15]:

client = ResourceManagementClient(
    credentials, 
    subscription_id
)


# In[17]:

group_name = 'TestRG1'

resource_group_params = {'location':'eastus'}

client.resource_groups.create_or_update(group_name, resource_group_params)


print ("Created Resource Group:", group_name)


# In[18]:

deployment_name = 'testvm'


# In[20]:

template = TemplateLink(

    uri='https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-linux/azuredeploy.json',

)


parameters = ParametersLink(

    uri='https://raw.githubusercontent.com/dstolts/Azure_Classroom/Heather/createbaseVM/Python/azuredeploy.parameters.json',

)


result = client.deployments.create_or_update(

    group_name,

    deployment_name,

    properties=DeploymentProperties(

        mode=DeploymentMode.incremental,

        template_link=template,

        parameters_link=parameters,

    )

)
print("Created Deployment:", deployment_name)


# In[31]:



