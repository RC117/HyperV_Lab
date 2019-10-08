. .\VmModule.ps1

$path = "D:\VMs"
$parentPath = "D:\VMs\Base\Virtual Hard Disks\Base.vhdx"
# Remove-VMAndVHD -VmName Test1 - ## DO NOT REMOVE!!!!!! ##
Remove-VMAndVHD -VmName Test2
# Remove-VMAndVHD -VmName Test3

# Add-DiffVm -VmName Test1 -Path $path -ParentPath $parentPath -SwitchName Lan - ## DO NOT REMOVE!!!!!! ##
Add-DiffVm -VmName Test2 -Path $path -ParentPath $parentPath -SwitchName Lan
# Add-DiffVm -VmName Test3 -Path $path -ParentPath $parentPath -SwitchName Lan



#####################################################################################################
#####################################################################################################

# Change IP address - TO REFACTOR!!!!!

Enable-VMIntegrationService -VMName "Test2" -Name "Guest Service Interface"

Start-VM -VMName Test2
do {
    $vm = Get-VM -VMName Test2
} while ($vm.Heartbeat -ne "OkApplicationsHealthy")

$managedCred = Get-StoredCredential -Target MyVMs # Create "Generic credential" in Credential Manager in Windows
Invoke-Command -VMName Test2 -ScriptBlock { 
    (New-NetIPAddress -IPAddress 169.254.0.3 -DefaultGateway 169.254.0.1 -PrefixLength 24 -InterfaceIndex (Get-NetAdapter).InterfaceIndex) 
} -Credential $managedCred

## Then let ping through firewall!!

