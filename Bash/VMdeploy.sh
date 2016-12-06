#!/bin/bash

usage() { echo "Usage: $0 [resourceGroupName] [ImageURL]"  }
#Assumptions: Azure agent already installed on image
# https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-create-upload-ubuntu/
# instal Azure Agent on VM: 
#     sudo apt-get update
#     sudo apt-get install walinuxagent
# we are already logged in to azure and have defaults set
#azure account set $subscriptionId
#switch the mode to azure resource manager
#azure config mode arm


# TODO Make Variable
resourceGroupName=$1 
IMAGE_URL=$2

if [[ -z $resourceGroupName ]]; then
   echo 'assigning default ResourceGroupName'
   resourceGroupName="XXXClassRG5"
fi
if [[ -z $IMAGE_URL ]]; then
   echo 'assigning default image'
   IMAGE_URL='https://XXXtfkuseast2.blob.core.windows.net/publicimage/Microsoft.Compute/Images/vhds/XXX-osDisk.1368efe0-4e2b-49cc-a067-a8d63ba7f64e.vhd'
fi
# EXPORT to env variables
export AZURE_RESOURCE_GROUP=$resourceGroupName
export AZURE_IMAGE_URL=$IMAGE_URL


#Create UniqueID
azUniqueId=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 12 | head -n 1)
azUniqueName="${athena_user}${azUniqueId}" 
export AZURE_UNIQUE_ID=$azUniqueName
echo "UniqueID: '$azUniqueName'"
# DEBUG then you can test it with...
#   (azure storage account check -v $azUniqueName) 


#Create resource group
resourceLocation="eastus2"
echo "Creating a new resource group... '$resourceGroupName' '$resourceLocation'" 
azure group create --name $resourceGroupName --location $resourceLocation

# create the storage account if it doesn't exist
storageAccountName=$azUniqueName"stor"
echo $storageAccountName 
DEST_CONTAINER="studentimage"
a=$(azure storage account show -g $resourceGroupName $storageAccountName --json | jq ".name")
if [[ -z $a ]]; then
   echo 'create Storage account'
   azure storage account create \
      --location $resourceLocation \
	  --sku-name "LRS" \
	  --resource-group $resourceGroupName \
	  --kind "Storage" \
	  $storageAccountName
fi

# get the access key
AZURE_STORAGE_ACCESS_KEY=$(azure storage account keys list -g $resourceGroupName $storageAccountName --json | jq '.[0] | .value' | sed -e 's/^"//' -e 's/"$//' )
	# Parsing the access key: 
	#     jq '.[0] = grab the first record
	#     .value'  = grab the value of the current record
	#     sed -e 's/^"//' -e 's/"$//'  = If there is a leading and trailing " double-quote, strip it
echo "Azure Storage Account Name: '$storageAccountName'"
echo "Azure Storage Access Key: '$AZURE_STORAGE_ACCESS_KEY'"
# set env variable for later storage commands
export AZURE_STORAGE_ACCOUNT=$storageAccountName
export AZURE_STORAGE_ACCESS_KEY=$AZURE_STORAGE_ACCESS_KEY

#Get Connection string
DEST_CONN=$(azure storage account connectionstring show --resource-group $resourceGroupName $storageAccountName --json | jq '. | .string' | sed -e 's/^"//' -e 's/"$//')
echo $DEST_CONN

IMAGE_VHD_NAME="XXXstudent.vhd"

# Create the folder [storageContainer] if it does not exist
c=$(azure storage container show $DEST_CONTAINER --json | jq '.name')
if [[ -z $c ]]; then
   azure storage container create -c $DEST_CONN $DEST_CONTAINER
fi

azure storage blob copy start \
    --source-uri $IMAGE_URL \
    --dest-container $DEST_CONTAINER \
    --dest-blob $IMAGE_VHD_NAME \
    --dest-connection-string $DEST_CONN
    
	"type": "Microsoft.Storage/storageAccounts",
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "kind": "Storage",
            "name": "[parameters('storageAccounts_dlsuxwhett1n9ej_name')]",
            "apiVersion": "2016-01-01",
            "location": "eastus",
            "tags": {},
            "properties": {},
            "resources": [],
            "dependsOn": []



echo "Copying master image to your loal account..."

STATUS="pending"
while [  $STATUS = "pending" ]; do
    result=$(azure storage blob copy show $DEST_CONTAINER $IMAGE_VHD_NAME -c $DEST_CONN --json | jq '. | .copy')
    progress=$(echo $result | jq '. | .progress' | sed -e 's/^"//' -e 's/"$//')
    echo "Current Progress is: "$progress # Calculate %complete? (copied/total)/100
    STATUS=$(echo $result | jq '. | .status' | sed -e 's/^"//' -e 's/"$//')
    sleep 9
done

echo $DEST_CONTAINER
IMAGE_FQDN=$(azure storage account show $storageAccountName -g $resourceGroupName --json | jq '. | .primaryEndpoints.blob' | sed -e 's/^"//' -e 's/"$//')
echo "Image FQDN: $IMAGE_FQDN"

IMAGE_PATH=$(azure storage blob list --container $DEST_CONTAINER --connection-string $DEST_CONN --json | jq '.[] | .name' | sed -e 's/^"//' -e 's/"$//')
 
echo "Image Path: $IMAGE_PATH"
IMAGE_URL=$IMAGE_FQDN$DEST_CONTAINER"/"$IMAGE_PATH
echo "url: $IMAGE_URL"

#publicIpName=''

# Create Virtual Network
azure network vnet create --resource-group $resourceGroupName --location $resourceLocation \
    --name StudentVNet --address-prefixes 10.0.0.0/16 

#azure network vnet delete --resource-group $resourceGroupName --name StudentVNet

# Create subnet(s)
azure network vnet subnet create --resource-group $resourceGroupName \
    --vnet-name StudentVNet \
    --name FrontEnd --address-prefix 10.0.1.0/24
azure network vnet subnet create --resource-group $resourceGroupName \
    --vnet-name StudentVNet \
    --name BackEnd --address-prefix 10.0.2.0/24
# Create Nics
azure network nic create --resource-group $resourceGroupName --location $resourceLocation \
    -n NIC1 --subnet-vnet-name StudentVNet --subnet-name FrontEnd
azure network nic create --resource-group $resourceGroupName --location  $resourceLocation \
    -n NIC2 --subnet-vnet-name StudentVNet --subnet-name BackEnd
	
# Create VM ...
azure vm create --admin-username "XXXadmin" --admin-password "AzureRocks!" \
    --resource-group $resourceGroupName \
	--location $resourceLocation \
    --storage-account-name $storageAccountName \
	--name "XXXClassVM" \
	--vm-size "Standard_DS1" \
	--os-type "linux" \
	--public-ip-name "NewVM-ip" \
	--generate-ssh-keys \
	--public-ip-domain-name $azUniqueName \
	--public-ip-allocation-method "Dynamic" \
	--public-ip-idletimeout 3 \
	--vnet-name "StudentVNet" \
	--vnet-subnet-name FrontEnd \
	--nic-names NIC1 \
	--os-disk-vhd $IMAGE_URL \
	--storage-account-container-name $DEST_CONTAINER \
	--ssh-publickey-file ~/.ssh/id_rsa.pub


#azure network nsg rule create --resource-group $resourceGroupName --nsg-name student-nsg --access Allow --protocol Tcp --direction Inbound --priority 200 --source-address-prefix Internet --source-port-range '*' --destination-address-prefix '*' --name 'ssh' --destination-port-range 22
#subnet-id or vnet-name, vnet-address-prefix, subnet-name and vnet-subnet-address-prefix
# -i, --public-ip-name <public-ip-name>                                  the public ip name

