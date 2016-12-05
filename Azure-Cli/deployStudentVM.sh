#!/bin/bash
# 
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -r | --resource-group)
    RESOURCE="$2"
    shift
    ;;
    -i | --image-url)
    IMAGE_URL="$2"
    shift
    ;;
esac
shift
done
# RESOURCE="schoolClassRG" 

#Create UniqueID for StorageAccount
azunique=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 12 | head -n 1)
azstoreid="${athena_user}${azunique}" 
# DEBUG then you can test it with...
#   (azure storage account check -v $azstoreid) 

azure group create $RESOURCE eastus
echo "Created resource group:" $RESOURCE

#Create StorageAcct Parameters JSON file
echo '
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountType": {
      "value": "Premium_LRS"
    },
    "storageAccountName": {
      "value": "'$azstoreid'"
    }
  }
}
' > templates/schoolStorageAcct.parameters.json

azure group deployment create $RESOURCE $RESOURCE"StorDepl" \
  --template-file templates/schoolStorageAcct.json \
  --parameters-file templates/schoolStorageAcct.parameters.json
echo "Created storage templates//schoolStorageAcct.parameters.json"

DEST_CONN=$(azure storage account connectionstring show --resource-group $RESOURCE $azstoreid --json | jq '. | .string' | sed -e 's/^"//' -e 's/"$//')
echo $DEST_CONN

IMAGE_VHD_NAME="schoolstudent.vhd"
DEST_CONTAINER="studentimage"
azure storage container create -c $DEST_CONN $DEST_CONTAINER

azure storage blob copy start \
    --source-uri $IMAGE_URL \
    --dest-container $DEST_CONTAINER \
    --dest-blob $IMAGE_VHD_NAME \
    --dest-connection-string $DEST_CONN

echo "Copying master image to your loal account..."

STATUS="pending"
while [  $STATUS = "pending" ]; do
    result=$(azure storage blob copy show $DEST_CONTAINER $IMAGE_VHD_NAME -c $DEST_CONN --json | jq '. | .copy')
    progress=$(echo $result | jq '. | .progress' | sed -e 's/^"//' -e 's/"$//')
    echo "Current Progress is: "$progress
    STATUS=$(echo $result | jq '. | .status' | sed -e 's/^"//' -e 's/"$//')
    sleep 9
done

echo $DEST_CONTAINER
IMAGE_FQDN=$(azure storage account show $azstoreid -g $RESOURCE --json | jq '. | .primaryEndpoints.blob' | sed -e 's/^"//' -e 's/"$//')
echo "Image FQDN: $IMAGE_FQDN"

IMAGE_PATH=$(azure storage blob list --container $DEST_CONTAINER --connection-string $DEST_CONN --json | jq '.[] | .name' | sed -e 's/^"//' -e 's/"$//')
 
echo "Image Path: $IMAGE_PATH"
IMAGE_URL=$IMAGE_FQDN$DEST_CONTAINER"/"$IMAGE_PATH
echo "url: $IMAGE_URL"

echo '
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUserName": {
      "value": "schoolstudent"
    },
    "sshKeyData": {
      "value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB0UcT8Fm/mBMKtKzPcBaCVTYA8Ii6MKYPADAWB1lKlw1wG6N+pJdNsvSqb4m7xk/HmtvMojw0CMXKSJdDq/qNprdst3sgnxdCHFhA8eBQc4AFPgg8KkzZ6MLnSfJYwZRDGEe3wjQS480LSazUExGsuQoMxzBRtJsQ02MB/N8ouGrShZp5NK51mjfhlffbkENMQNmhTsfW33ZZP32gLCeXzgZmv/Cwo6144Q4VPUFFl5wl3/VfdGyWLiZyIPGzhU4yPR+ibDxR/X1WQN290y1vAj7tz/qq6XiWYTEAEgsc2NRgiL00CoN3kgBpU8Dh/evm87BDLZ8IYNhWNPIzQV3/ tdradmin@tdrbox"
    },
    "vmSize": {
      "value": "Standard_DS1"
    },
    
    "customImageName": {
      "value": "'$IMAGE_PATH'"
    },
    "storageAccountName": {
      "value": "'$azstoreid'"
    },
    "newVmName": {
      "value": "StudentVM"
    },
    "vhdStorageAccountContainerName": {
      "value": "'$DEST_CONTAINER'"
    }
   }
}
' > templates/schoolGoldVM.parameters.json
    
azure group deployment create $RESOURCE $RESOURCE"VmDepl" \
  --template-file templates/schoolGoldVM.json \
  --parameters-file templates/schoolGoldVM.parameters.json