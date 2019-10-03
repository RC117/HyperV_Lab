. .\VmModule.ps1

$path = "D:\VMs"
$parentPath = "D:\VMs\Base\Virtual Hard Disks\Base.vhdx"
Remove-VMAndVHD -VmName Test1
Remove-VMAndVHD -VmName Test2
Remove-VMAndVHD -VmName Test3
Add-DiffVm -VmName Test1 -Path $path -ParentPath $parentPath -SwitchName Lan
Add-DiffVm -VmName Test2 -Path $path -ParentPath $parentPath -SwitchName Lan
Add-DiffVm -VmName Test3 -Path $path -ParentPath $parentPath -SwitchName Lan

# TODO: change ip on new vm, add Internet switch,turn on vm