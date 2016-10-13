
# coding: utf-8

# In[ ]:

##pip3 install --pre azure
##pip4 install msrest
##pip3 install msrestazure


# In[39]:

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


# In[65]:

with open("az_config.json") as data_file:

    data = json.load(data_file)

    

def get_credentials(config_data):

    return UserPassCredentials(

        config_data["username"],

        config_data["password"],

    )


# In[66]:

credentials = get_credentials(data)

print("Creds have been delivered from:", credentials.cred_store)


# In[67]:

client = ResourceManagementClient(
    credentials, 
    subscription_id
)


# In[68]:

group_name = 'classroomRG'

resource_group_params = {'location':'eastus'}

client.resource_groups.create_or_update(group_name, resource_group_params)


print ("Created Resource Group:", group_name)


# In[57]:

deployment_name = 'testVM1'


# In[64]:

template = TemplateLink(

    uri='https://raw.githubusercontent.com/dstolts/Azure_Classroom/master/Python%20Scripts/azuredeploy.json',

)


parameters = ParametersLink(

    uri='https://raw.githubusercontent.com/dstolts/Azure_Classroom/master/Python%20Scripts/azuredeploy.parameters.json',

)


result = resource_client.deployments.create_or_update(

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



