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

from tkinter import *
import tkinter.messagebox as tm

from pathlib import Path

from azure.storage.blob import PublicAccess
import pprint


class LoginFrame(Frame):

    def __init__(self, master):
        super().__init__(master)

        Label(root, text="Please enter your Azure Credentials").pack()
        self.label_1 = Label(self, text="Username")
        self.label_2 = Label(self, text="Password")
        self.label_3 = Label(self, text="Subscription Id")

        self.entry_1 = Entry(self)
        self.entry_2 = Entry(self, show="*")
        self.entry_3 = Entry(self)

        self.label_1.grid(row=0, sticky=E)
        self.label_2.grid(row=1, sticky=E)
        self.label_3.grid(row=2, sticky=E)
        self.entry_1.grid(row=0, column=1)
        self.entry_2.grid(row=1, column=1)
        self.entry_3.grid(row=2, column=1)

        self.logbtn = Button(
            self, text="Save", command=self._login_btn_clickked)
        self.logbtn.grid(columnspan=2)

        self.pack()

    def _login_btn_clickked(self):

        username = self.entry_1.get()
        password = self.entry_2.get()
        subscription_id = self.entry_3.get()

        data = {"username": username, "password": password,
                "subscription_id": subscription_id}
        filename = "az_config.json"
        with open(filename, 'w+') as temp_file:
            json.dump(data, temp_file)

        root.destroy()


def get_credentials(config_data):

    return UserPassCredentials(

        config_data["username"],

        config_data["password"],

    )


def get_subscription(config_data):
    return config_data["subscription_id"]

# prompt for credentials


my_file = Path("az_config.json")
if not my_file.is_file():
    root = Tk()
    lf = LoginFrame(root)
    root.mainloop()
with open("az_config.json") as data_file:
    data = json.load(data_file)


# get credentials

credentials = get_credentials(data)
subscription_id = get_subscription(data)
print("Creds have been delivered from:", credentials.cred_store)


# set up RM client

client = ResourceManagementClient(
    credentials,
    subscription_id
)
print("The client was set up")


# create resource group

group_name = 'TestRG'

resource_group_params = {'location': 'eastus'}


client.resource_groups.create_or_update(
    group_name, resource_group_params, public_access=PublicAccess.Container)


print("Created Resource Group:", group_name)


# create deployment name

deployment_name = 'testvm'


# In[86]:

# create deployment using templatelink

template = TemplateLink(
    uri='https://raw.githubusercontent.com/dstolts/Azure_Classroom/master/Python/azuredeploy.json',
)

parameters = ParametersLink(

    uri='https://raw.githubusercontent.com/dstolts/Azure_Classroom/master/Python/azuredeploy.parameters.json',

)

result = client.deployments.create_or_update(

    group_name,

    deployment_name,

    properties=DeploymentProperties(

        mode=DeploymentMode.incremental,

        template_link=template,
    
        parameters_link=parameters
    )

)

pprint.pprint(result)
print("Created Deployment:", deployment_name)
print(deployment_name + " is being deployed...")
result.wait()
print("The deployment finished successfully")
