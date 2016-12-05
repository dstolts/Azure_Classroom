Param(
[string]$1,
[string]$2
)
### usage ./captureimage.ps1 ResourceGroupName VMName
#$1 = Resource
#$2 = VMName

# Capture VM and RG data in variables
$vm = Get-AzureRmVm $1 $2 
$osvhduri = $vm.StorageProfile.OsDisk.Vhd.Uri
$pip = ".eastus.cloudapp.azure.com"

# Capture sorage account name, nic, FQND and vm Image Name
$VM_STOR_ACCT_NAME = Get-AzureRmStorageAccount $1 -Name $osvhduri.split('/')[2].split('.')[0] | Select-Object -ExpandProperty StorageAccountName
$get_vm_nic = $vm.NetworkInterfaceIDs.split('/')[8] -replace("nic","pip")
$get_vm_fqdn = $get_vm_nic + $pip
$get_vm_image_name = $vm.StorageProfile.OsDisk.Name

### Begin Azure Capture

azure vm deallocate -g $1 -n $2
azure vm generalize -g $1 -n $2
azure vm capture $1 $2 Custom -t Custom_Image.json

### End Azure Capture

### Begin Storage Account Copy ###
# Get Source Storage account key
$sourceKey = Get-AzureRmStorageAccountKey $1 $VM_STOR_ACCT_NAME 
$srcStorageKey = ($sourceKey.value -split '\n')[0] 

# Create source context for authenticating the copy
$srcCtx = New-AzureStorageContext -StorageAccountName $VM_STOR_ACCT_NAME `
                                  -StorageAccountKey $srcStorageKey

# Source VHD, Container and Blob info
$srcContainer = "system"
Write-Output "Basevm storage account name: $VM_STOR_ACCT_NAME"
$blobURI = $osvhduri.split("/")[0, 1, 2] -join '/'
$captureDisk = Get-AzureStorageBlob -Container $srcContainer -Context $srcCtx
$srcBlob = $captureDisk.Name

# Destination Storage Account
$destStorageAcct = "customtestimagestor"

# Create Destination Storage account
New-AzureRmStorageAccount $1 -SkuName Standard_LRS -Location eastus -Kind Storage $destStorageAcct

# Get Destination storage account key
$destKey = Get-AzureRmStorageAccountKey $1 $destStorageAcct
$destStorageKey = ($destKey.value -split '\n')[0]

# Create destination context for authenticating the copy
$destContext = New-AzureStorageContext -StorageAccountName $destStorageAcct `
                                       -StorageAccountKey $destStorageKey
# Destination Container Name
$destContainerName = "publicimage"

# Create the target container in storage
New-AzureStorageContainer -Name $destContainerName -Context $destContext -Permission blob

# Start Asynchronus Copy #
$blob1 = Start-AzureStorageBlobCopy -SrcBlob $srcBlob `
                                    -SrcContainer $srcContainer `
                                    -DestContainer $destContainerName `
                                    -Context $srcCtx `
                                    -DestContext $destContext

### Check Status of Blob Copy ###
$status = $blob1 | Get-AzureStorageBlobCopyState

## Print status of Blob copy state ##
$status

### Loop until complete
While($status.Status -eq "Pending"){
    $status = $blob1 | Get-AzureStorageBlobCopyState
    Start-Sleep 10
    ### Print out status ###
    $status
}

#Image FQDN
$ImageURI = (Get-AzureStorageBlob -Context $destContext -blob $srcBlob -Container $destContainerName).ICloudBlob.uri.AbsoluteUri
Write-Output "`n"
Write-Output "Your Image URI is: $ImageURI"