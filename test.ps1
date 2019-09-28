# create a diff disk for each vm
# create a vm connecting to that new diff disk

# Create diff disk
New-VHD -Path D:\VMs\Test1Diff.vhdx -ParentPath 'D:\VMs\Base\Virtual Hard Disks\Base.vhdx' -Differencing

# create vm using new diff disk

New-VM -Name "Test1" -Generation 2 -MemoryStartupBytes 3072MB -VHDPath 'D:\VMs\Test1Diff.vhdx' -SwitchName Internet
Get-VM Test1 | Add-VMNetworkAdapter -SwitchName Lan
Start-VM -Name Test1

