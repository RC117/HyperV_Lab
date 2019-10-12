. .\VmModule.ps1

$Test2VmName = 'Test2'
$Test3VmName = 'Test3'
$path = "D:\VMs"
$parentPath = "D:\VMs\Base\Virtual Hard Disks\Base.vhdx"
# # Remove-VMAndVHD -VmName Test1 - ## DO NOT REMOVE!!!!!! ##
Remove-VMAndVHD -VmName $Test2VmName
Remove-VMAndVHD -VmName $Test3VmName

# # # Add-DiffVm -VmName Test1 -Path $path -ParentPath $parentPath -SwitchName Lan - ## DO NOT REMOVE!!!!!! ##

Add-DiffVm -VmName $Test2VmName -Path $path -ParentPath $parentPath -SwitchName Lan
Update-IP -VmName $Test2VmName -IpAddress '169.254.0.102' -DefaultGateway '169.254.0.100'
Add-SwitchToVm -VmName $Test2VmName -SwitchName Internet

Add-DiffVm -VmName $Test3VmName -Path $path -ParentPath $parentPath -SwitchName Lan
Update-IP -VmName $Test3VmName -IpAddress '169.254.0.103' -DefaultGateway '169.254.0.100'
Add-SwitchToVm -VmName $Test3VmName -SwitchName Internet


#####################################################################################################
#####################################################################################################
