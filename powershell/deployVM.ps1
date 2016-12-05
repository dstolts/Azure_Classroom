Param(
[string]$1,
[string]$2
)
# usage ./captureimage.ps1 ResourceGroupName VMName
#$1 = Resource
#$2 = Image URL

#Create UniqueID for StorageAccount
$uniq_user = $env:USERPROFILE.Split('\')[2]
$azunique = -join ([char[]](48..57+97..122)*100 | Get-Random -Count 12)
$azstoreid = $uniq_user + $azunique
echo "Your azstoreid is $azstoreid"

# DEBUG then you can test it with...
#   (azure storage account check -v $azstoreid) 

#Resource Group Create

New-AzureRMResourceGroup $1 eastus

Write-Output "Created resource group: $1"

#Create StorageAcct Parameters JSON file
Write-Output @" 
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountType": {
      "value": "Premium_LRS"
    },
    "storageAccountName": {
      "value": "$azstoreid"
    }
  }
} 
"@ > "templates\CustStorageAcct.parameters.json"

Write-Output "Created Storage templates\CustStorageAcct.Parameters.json"

# New Azure Deployment
# Splat prop for deployment
$prop = @{
    Name = "StorDepl";
    ResourceGroupName = $1;
    TemplateFile = ".\templates\CustStorageAcct.json";
    TemplateParameterFile = ".\templates\CustStorageAcct.parameters.json"

}

New-AzureRmResourceGroupDeployment @prop

# End Azure Deployment Part 1

### Azure Storage Connection and copy ###

#Destination VHD - Image VHD Name
$destBlob = "customimage.vhd"

#Destination container name
$destContainerName = "customimage"

#Get Destination storage account key
$destKey = Get-AzureRmStorageAccountKey $1 $azstoreid
$destStorageKey = ($destKey.value -split '\n')[0]
echo "Destination key: $destStorageKey"

## Create Destination context for authenticating the copy
$destContext = New-AzureStorageContext -StorageAccountName $azstoreid `
                                       -StorageAccountKey $destStorageKey

## Create the detination container in storage account
New-AzureStorageContainer -Name $destContainerName `
                          -Context $destContext 
                                
### Start Asynchronus Copy ###
$blobcopy = @{
        AbsoluteUri = $2
        DestBlob = $destBlob
        DestContainer = $destContainerName
        DestContext = $destContext
}

$blob = Start-AzureStorageBlobCopy @blobcopy

Write-Output "Copying master image to your local account..."

### Check Status of Blob Copy ###
$status = Get-AzureStorageBlobCopyState -Blob $destBlob -Container $destContainerName -Context $destContext

## Print status of Blob copy state ##
$status

### Loop until complete
While($status.Status -eq "Pending"){
    $status = Get-AzureStorageBlobCopyState -Blob $destBlob -Container $destContainerName -Context $destContext
    Start-Sleep 10
    ### Print out status ###
    $status
}

#Image URI Output
$storBlob = Get-AzureStorageBlob -Container $destContainerName -Context $destContext
$destBlob = $storBlob.Name
$ImageURI = (Get-AzureStorageBlob -Context $destContext -blob $destBlob -Container $destContainerName).ICloudBlob.uri.AbsoluteUri
Write-output "Your local copy image URI is: $ImageURI"

## Image path for CustomImageName in Custom Gold Parameters JSON Template
#$IMAGE_PATH = $storBlob.Name.Split('/')[3]
#Write-Output "Your Image Path is: $IMAGE_PATH"

## Custom Gold Parameters Json Creation
Write-Output @"
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUserName": {
      "value": "customimage"
    },
    "sshKeyData": {
      "value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB0UcT8Fm/mBMKtKzPcBaCVTYA8Ii6MKYPADAWB1lKlw1wG6N+pJdNsvSqb4m7xk/HmtvMojw0CMXKSJdDq/qNprdst3sgnxdCHFhA8eBQc4AFPgg8KkzZ6MLnSfJYwZRDGEe3wjQS480LSazUExGsuQoMxzBRtJsQ02MB/N8ouGrShZp5NK51mjfhlffbkENMQNmhTsfW33ZZP32gLCeXzgZmv/Cwo6144Q4VPUFFl5wl3/VfdGyWLiZyIPGzhU4yPR+ibDxR/X1WQN290y1vAj7tz/qq6XiWYTEAEgsc2NRgiL00CoN3kgBpU8Dh/evm87BDLZ8IYNhWNPIzQV3/ tdradmin@tdrbox"
    },
    "vmSize": {
      "value": "Standard_DS1"
    },
    
    "customImageName": {
      "value": "$destBlob"
    },
    "storageAccountName": {
      "value": "$azstoreid"
    },
    "newVmName": {
      "value": "CustomVM"
    },
    "vhdStorageAccountContainerName": {
      "value": "$destContainerName"
    }
   }
}
"@ > templates\CustomGoldVM.parameters.json

Write-Output "Created Storage templates\CustomGoldVM.Parameters.json"
## End Custom Gold Parameters Json Creation

# Begin Azure Deployment Part 2
# Deployment Splat
$param = @{
    Name = "VmDepl";
    ResourceGroupName = $1;
    TemplateFile = ".\templates\CustomGoldVM.json";
    TemplateParameterFile = ".\templates\CustomGoldVM.parameters.json"

}

New-AzureRmResourceGroupDeployment @param 
# End Azure Deployment Part 2