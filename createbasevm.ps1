#Azure CLI for quick create 
azure vm quick-create -g Class -n basevm "eastus" -y Linux -Q canonical:ubuntuserver:14.04.2-LTS:latest -u tdradmin -M id_rsa.pub

$vm = azure vm show mitclass basevm --json | Convertfrom-Json
$nic_id = $vm.networkProfile.networkInterfaces[0] | Select-Object -ExpandProperty id
$nic_name = $nic_id.Split('/')[8] -replace("nic","pip")
$pip = ".eastus.cloudapp.azure.com"
$fqdn = $nic_name + $pip

Write-Output "`n"
Write-Output "`n"
Write-Output "SSH Connection String: ssh tdradmin@$fqdn"
Write-Output "Deprovision Command: sudo waagent deprovision+user -force" 
