#!/bin/bash
# usage ./captureimage.sh ResourceGroupName VMName
#
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -r | --resource-group)
    RESOURCE="$2"
    shift
    ;;
    -v | --vm-name)
    VMNAME="$2"
    shift
    ;;
esac
shift
done

get_vm_storage_account_name ()
{
    result=$(azure vm show $1 $2 --json)
    uri=$(echo $result | jq '. | .storageProfile.osDisk.vhd.uri' | sed -e 's/^"//' -e 's/"$//')
    proto="$(echo $uri | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    url="$(echo ${uri/$proto/})"
    user="$(echo $url | grep . | cut -d. -f1)"
    echo $user
}

get_vm_fqdn ()
{
    nic_id=$(azure vm show $1 $2 --json | jq '. | .networkProfile.networkInterfaces | .[0].id' | sed -e 's/^"//' -e 's/"$//')
    nic_name=(${nic_id//// })
    pub_ip_id=$(azure network nic show schoolclass ${nic_name[-1]} --json | jq '. | .ipConfigurations | .[0].publicIPAddress.id' | sed -e 's/^"//' -e 's/"$//')
    pub_ip_name=(${pub_ip_id//// })
    fqdn=$(azure network public-ip show $1 ${pub_ip_name[-1]} --json | jq '. | .dnsSettings.fqdn' | sed -e 's/^"//' -e 's/"$//')
    echo $fqdn
}

get_vm_image_name ()
{
    image_name=$(azure storage blob list $1 -c $2 --json | jq '.[] | .name' | sed -e 's/^"//' -e 's/"$//')
    echo $image_name
}

SOURCE_CONTAINER="system"
DEST_CONTAINER="publicimage"
BLOB_NAME_PATH="Microsoft.Compute/Images/vhds/"
IMAGE_STOR_ACCT="schooltestimagestor"
# need to serialize accountname ...
#Create UniqueID for StorageAccount
azuniqueMaster=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 12 | head -n 1)
azstoreMaster="${athena_user}${azunique}" 
# above variables are not being used yet becuase need to vet out rest of script before enabling.
# [DAN] I wonder if this is the best approach?  Must we create a new storage account? 
#       If we create a new storage account for the destination, we will need to send the new cert to clients
#       Need to simplify

VM_STOR_ACCT_NAME=$(get_vm_storage_account_name $RESOURCE $VMNAME)
echo "Basevm storage account name: "$VM_STOR_ACCT_NAME

SOURCE_CONN=$(azure storage account connectionstring show --resource-group $RESOURCE $VM_STOR_ACCT_NAME --json | jq '. | .string' | sed -e 's/^"//' -e 's/"$//')
echo "Storage Account connectionstring: "$SOURCE_CONN

VM_FQDN=$(get_vm_fqdn $RESOURCE $VMNAME)
echo "Basevm FQDN is "$VM_FQDN

# TODO add current user to sudoers file
# TODO how do you accept unknown host prompt?
# ssh $FQDN 'sudo waagent -deprovision+user -force'
# echo 'Deprovisioned OS'

azure vm deallocate -g $RESOURCE -n $VMNAME
azure vm generalize -g $RESOURCE -n $VMNAME
azure vm capture $RESOURCE $VMNAME school -t school_Image.json

# Create new stroage account
azure storage account create -g $RESOURCE --sku-name LRS --location eastus --kind Storage $IMAGE_STOR_ACCT
DEST_CONN=$(azure storage account connectionstring show --resource-group $RESOURCE $IMAGE_STOR_ACCT --json | jq '. | .string' | sed -e 's/^"//' -e 's/"$//')
echo "Dest conn: "$DEST_CONN

# create new public container
azure storage container create $DEST_CONTAINER -c $DEST_CONN -p Blob

# copy image to new location
IMAGE_VHD_NAME=$(get_vm_image_name $SOURCE_CONTAINER $SOURCE_CONN)
echo $IMAGE_VHD_NAME

azure storage blob copy start \
    --source-container $SOURCE_CONTAINER \
    --source-blob $IMAGE_VHD_NAME \
    --dest-container $DEST_CONTAINER \
    --connection-string $SOURCE_CONN \
    --dest-connection-string $DEST_CONN

STATUS="pending"
while [  $STATUS = "pending" ]; do
    result=$(azure storage blob copy show $DEST_CONTAINER $IMAGE_VHD_NAME -c $DEST_CONN --json | jq '. | .copy')
    progress=$(echo $result | jq '. | .progress' | sed -e 's/^"//' -e 's/"$//')
    echo "Current Progress is: "$progress
    STATUS=$(echo $result | jq '. | .status' | sed -e 's/^"//' -e 's/"$//')
    sleep 9
done