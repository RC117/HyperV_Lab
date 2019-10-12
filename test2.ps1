. .\VmModule.ps1

$path = "D:\VMs"
$parentPath = "D:\VMs\Base\Virtual Hard Disks\Base.vhdx"
# # Remove-VMAndVHD -VmName Test1 - ## DO NOT REMOVE!!!!!! ##
Remove-VMAndVHD2 -VmName Test2
# Remove-VMAndVHD -VmName Test3

# # # Add-DiffVm -VmName Test1 -Path $path -ParentPath $parentPath -SwitchName Lan - ## DO NOT REMOVE!!!!!! ##
# Add-DiffVm -VmName Test2 -Path $path -ParentPath $parentPath -SwitchName Lan
# Update-IP -VmName Test2 -IpAddress '169.254.0.102' -DefaultGateway '169.254.0.100'

# Add-DiffVm -VmName Test3 -Path $path -ParentPath $parentPath -SwitchName Lan
# Update-IP -VmName Test3 -IpAddress '169.254.0.103' -DefaultGateway '169.254.0.100'

# add back in "Internet" network to both VMs (might have to stop vm(or restart it afterwards?))

#####################################################################################################
#####################################################################################################
