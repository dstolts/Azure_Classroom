
# coding: utf-8
import pip

def import_or_install(package):
    try:
        __import__(package)
    except ImportError:
        pip.main(['install', package])  


import_or_install("json")
import_or_install("azure.common.credentials")
import_or_install("azure.mgmt.resource")
import_or_install("azure.mgmt.storage")
import_or_install("azure.storage")
import_or_install("azure.mgmt.resource.resources.models")
import_or_install("azure.storage.blob")
import_or_install("tkinter")
import_or_install("tkinter.messagebox")
import_or_install("pathlib")
import_or_install("pprint")

import json

from azure.common.credentials import UserPassCredentials

from azure.mgmt.resource import ResourceManagementClient

from azure.mgmt.storage import StorageManagementClient

from azure.storage import CloudStorageAccount

from azure.mgmt.resource.resources.models import ResourceGroup

from azure.mgmt.resource.resources.models import Deployment

from azure.mgmt.resource.resources.models import DeploymentProperties

from azure.mgmt.resource.resources.models import DeploymentMode

from azure.mgmt.resource.resources.models import ParametersLink
from azure.mgmt.resource.resources.models import TemplateLink


from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.mgmt.storage.models import StorageAccountCreateParameters
from azure.mgmt.storage.models import StorageAccountCreateParameters, Sku, SkuName, Kind
from azure.storage.blob import BlockBlobService
from azure.storage.blob import PublicAccess

from tkinter import *
import tkinter.messagebox as tm

from pathlib import Path


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
        filename = "az_config.json"
        with open(filename, 'w+') as temp_file:
            json.dump(data,temp_file)
        
        
        root.destroy()
    


# In[3]:

def get_credentials(config_data):

    return UserPassCredentials(

        config_data["username"],

        config_data["password"],

    )

def get_subscription(config_data):
    return config_data["subscription_id"]


# In[ ]:

##prompt for credentials


my_file = Path("az_config.json")
if not my_file.is_file():
    root = Tk()
    lf = LoginFrame(root)
    root.mainloop()
with open("az_config.json") as data_file:
    data = json.load(data_file)


credentials = get_credentials(data)
subscription_id = get_subscription(data)
print("Creds have been delivered from:", credentials.cred_store)



compute_client = ComputeManagementClient(credentials, subscription_id)


resource_group_name = "TestRG"
vm_name = 'MyUbuntuVM'
result_deallocate = compute_client.virtual_machines.deallocate(resource_group_name, vm_name)
print("The vm is being deallocated...")
result_deallocate.wait()

# Generalize (possible because deallocated)
print("The vm is being generalized...")
compute_client.virtual_machines.generalize(resource_group_name, vm_name)


# Capture VM (VM must be generalized before)
print("the vm is being captured...")
async_capture = compute_client.virtual_machines.capture(
            resource_group_name, 
            vm_name,
            {
               "vhd_prefix":"pslib",
               "destination_container_name":"vhds",
               "overwrite_vhds": True
            }
        )
capture_result = async_capture.result()

capture_result

storage_client = StorageManagementClient(credentials, subscription_id)


for item in storage_client.storage_accounts.list_by_resource_group(resource_group_name):
    storage_account_name = item.name

storage_account = storage_client.storage_accounts.get_properties(
    resource_group_name, storage_account_name)


###Begin Storage account copy

##get storage 
storage_keys = storage_client.storage_accounts.list_keys( resource_group_name, storage_account_name)
storage_keys = {v.key_name: v.value for v in storage_keys.keys}

storage_key = storage_keys['key1']
print("The storage key is: " + storage_key)


#destination storage account
destStorageAcct = 'classroomtestimage'


# In[14]:

# Create Destination Storage account


print("Creating the storage account...")
storage_async_operation = storage_client.storage_accounts.create(
    resource_group_name,
    destStorageAcct,
    StorageAccountCreateParameters(
        sku=Sku(SkuName.standard_lrs),
        kind=Kind.storage,
        location='eastus',
    )
)
storage_account = storage_async_operation.result()
print(storage_account)

# In[15]:

# Source VHD, Container and Blob info

print("Getting the blob URL to copy...")
srcContainer = "system"

block_blob_service1 = BlockBlobService(account_name=storage_account_name, account_key=storage_key)

generator = block_blob_service1.list_blobs(srcContainer)
for blob in generator:
    if 'json' in blob.name:
        blob_name =blob.name
blob_url = block_blob_service1.make_blob_url(srcContainer,blob_name)
block_blob_service1.set_container_acl(srcContainer, public_access=PublicAccess.Container)
print("Updated access policy for source container")
print("The blob URL to copy is " +  blob_url)


# In[16]:

# Destination Container Name

destContainerName = "publicimage"


# In[17]:

##get destination storage account key
destStorage_keys = storage_client.storage_accounts.list_keys( resource_group_name, destStorageAcct)
destStorage_keys = {v.key_name: v.value for v in destStorage_keys.keys}

destStorage_key = destStorage_keys['key1']
print("The destination storage key is " + destStorage_key)


# In[18]:

# Create the target container in storage

block_blob_service2 = BlockBlobService(account_name=destStorageAcct, account_key=destStorage_key)


# In[19]:

block_blob_service2.create_container(destContainerName, public_access=PublicAccess.Container)


# In[21]:

# Start Asynchronus Copy #
print("Starting azure copy...")
block_blob_service2.copy_blob(destContainerName, "testBlob.json", blob_url)

print("Azure copy done.")
generator = block_blob_service2.list_blobs(destContainerName)
for blob in generator:
    blob_url2 = block_blob_service2.make_blob_url(destContainerName, blob.name)
    print("The new blob url is " + blob_url2)

