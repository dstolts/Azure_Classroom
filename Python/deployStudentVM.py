
# coding: utf-8

import pip

def import_or_install(package):
    try:
        __import__(package)
    except ImportError:
        pip.main(['install', package])  



# In[21]:
import_or_install("json")
import_or_install("azure.common.credentials")
import_or_install("azure.mgmt.resource")
import_or_install("azure.mgmt.storage")
import_or_install("azure.storage")
import_or_install("azure.mgmt.resource.resources.models")
import_or_install("azure.storage.blob")

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


# In[22]:

import_or_install("random")
import random
from random import randint

def random_with_N_digits(n):
    range_start = 10**(n-1)
    range_end = (10**n)-1
    return randint(range_start, range_end)


# In[23]:

athena_user = "hbs"
azunique = str(random_with_N_digits(12))
azurestoreid = athena_user + azunique
print("Your azurestoreid is " + azurestoreid)


# In[24]:

def get_credentials(config_data):

    return UserPassCredentials(

        config_data["username"],

        config_data["password"],

    )

def get_subscription(config_data):
    return config_data["subscription_id"]


# In[25]:

import_or_install("tkinter")
import_or_install("tkinter.messagebox")
from tkinter import *
import tkinter.messagebox as tm



class LoginFrame(Frame):
    def __init__(self, master):
        super().__init__(master)

        self.label_1 = Label(self, text="Azure Email")
        self.label_2 = Label(self, text="Azure Password")
        self.label_3 = Label(self, text="Subscription Id")

        self.entry_1 = Entry(self)
        self.entry_2 = Entry(self, show="*")
        self.entry_3 = Entry(self)

        self.label_1.grid(row=0, sticky=E)
        self.label_2.grid(row=1, sticky=E)
        self.label_3.grid(row=2,sticky=E)
        self.entry_1.grid(row=0, column=1)
        self.entry_2.grid(row=1, column=1)
        self.entry_3.grid(row=2,column=1)

#         self.checkbox = Checkbutton(self, text="Save Credentials")
#         self.checkbox.grid(columnspan=2)

        self.logbtn = Button(self, text="Save", command = self._login_btn_clickked)
        self.logbtn.grid(columnspan=2)

        self.pack()

    def _login_btn_clickked(self):
        
        username = self.entry_1.get()
        password = self.entry_2.get()
        subscription_id = self.entry_3.get()
        
        data = {"username":username, "password":password, "subscription_id":subscription_id}
#         print(data)
        filename = "az_configStudent.json"
        with open(filename, 'w+') as temp_file:
            json.dump(data,temp_file)
        
        
        root.destroy()
    


# In[26]:

##prompt for credentials
import_or_install("json")
import json
import_or_install("pathlib")
from pathlib import Path

my_file = Path("az_configStudent.json")
if not my_file.is_file():
    root = Tk()
    lf = LoginFrame(root)
    root.mainloop()
with open("az_configStudent.json") as data_file:
    data = json.load(data_file)


# In[27]:

credentials = get_credentials(data)
subscription_id = get_subscription(data)
print("Creds have been delivered from:", credentials.cred_store)


# In[28]:

client = ResourceManagementClient(
    credentials, 
    subscription_id
)
print("The client was set up")


# In[29]:

##create resource group

group_name = 'StudentRG'

resource_group_params = {'location':'eastus'}

client.resource_groups.create_or_update(group_name, resource_group_params)


print ("Created Resource Group:", group_name)


# In[30]:

##create storage account template

import json


# In[33]:

##new azure deployment

deployment_name = 'testStudentVM'


# In[34]:

template = TemplateLink(
    uri= 'https://raw.githubusercontent.com/dstolts/Azure_Classroom/Jessica/Dev/templates/CustStorageAcct.json'

)


result = client.deployments.create_or_update(

    group_name,

    deployment_name,

    properties=DeploymentProperties(

        mode=DeploymentMode.incremental,

        template_link = template,
        parameters = {
                        "storageAccountType": {
                          "value": "Standard_LRS"
                        },
                        "storageAccountName": {
                          "value": azurestoreid
                        }
                      }

    )
)
print("Created Deployment:", deployment_name)
print(deployment_name + " is being deployed...")
result.wait()
# print("The deployment finished successfully")


# In[35]:

##create student vhd

vhdName = "student.vhd"

##destination container name 
destContainerName = "studentimage"


# In[36]:

from azure.mgmt.storage import StorageManagementClient

storage_client = StorageManagementClient(credentials, subscription_id)

destStorage_keys = storage_client.storage_accounts.list_keys( group_name, azurestoreid)
destStorage_keys = {v.key_name: v.value for v in destStorage_keys.keys}

destStorage_key = destStorage_keys['key1']
print("The deployment finished successfully")
print("Destination key: " +destStorage_key)


# In[37]:

from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.mgmt.storage.models import StorageAccountCreateParameters
from azure.mgmt.storage.models import StorageAccountCreateParameters, Sku, SkuName, Kind
from azure.storage.blob import BlockBlobService
from azure.storage.blob import PublicAccess


# In[43]:

# Create the target container in storage
destStorageAcct = azurestoreid
block_blob_service = BlockBlobService(account_name=destStorageAcct, account_key=destStorage_key)


# In[46]:
print("Creating the container...")
block_blob_service.create_container(destContainerName)
print("Updating the container access level")
block_blob_service.set_container_acl(destContainerName, public_access=PublicAccess.Container)



# In[48]:
print("starting the Azure Copy...")
blob_url="https://classroomtestimage.blob.core.windows.net/publicimage/testBlob.json"
block_blob_service.copy_blob(destContainerName, "testBlob.json", blob_url)



generator = block_blob_service.list_blobs(destContainerName)
for blob in generator:
    blob_url = block_blob_service.make_blob_url(destContainerName, blob.name)
    print(blob_url)