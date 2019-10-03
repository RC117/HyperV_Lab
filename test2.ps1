. .\VmModule.ps1

Remove-VMAndVHD -VmName Test1
Remove-VMAndVHD -VmName Test2
Remove-VMAndVHD -VmName Test3
Add-DiffVm -VmName Test1 -Path "D:\VMs" -ParentPath "D:\VMs\Base\Virtual Hard Disks\Base.vhdx" -SwitchName Lan
Add-DiffVm -VmName Test2 -Path "D:\VMs" -ParentPath "D:\VMs\Base\Virtual Hard Disks\Base.vhdx" -SwitchName Lan
Add-DiffVm -VmName Test3 -Path "D:\VMs" -ParentPath "D:\VMs\Base\Virtual Hard Disks\Base.vhdx" -SwitchName Lan

# TODO: change ip on new vm, add Internet switch,turn on vm