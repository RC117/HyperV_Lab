. .\VmModule.ps1

Remove-VMAndVHD -VmName Test1
Add-DiffVm -VmName Test1 -Path "D:\VMs" -ParentPath "D:\VMs\Base\Virtual Hard Disks\Base.vhdx" -SwitchName Lan