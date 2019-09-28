# create a diff disk for each vm
# create a vm connecting to that new diff disk

# Create diff disk
try {
    New-VHD -Path D:\VMs\Test1Diff.vhdx -ParentPath 'D:\VMs\Base\Virtual Hard Disks\Base.vhdx' -Differencing
}
Catch {
    Throw "The Hard disk could not be created"
}

# create vm using new diff disk
try {
    New-VM -Name "Test1" -Generation 2 -MemoryStartupBytes 3072MB -VHDPath 'D:\VMs\Test1Diff.vhdx' -SwitchName Lan
    
}
Catch {
    Throw "The VM could not be created"
}

# Start VM
try {
    Start-VM -Name Test1
    Enable-VMIntegrationService -VMName Test1 -Name "Guest Service Interface"
    # Invoke-Command -VMName Test1 -ScriptBlock { (Get-NetAdapter).InterfaceAlias } -Credential $cred
    # Get-VM Test1 | Add-VMNetworkAdapter -SwitchName Internet        
}
catch {
    Throw "Could not start VM"
}

try {
    # Invoke-Command -VMName Test1 -ScriptBlock { (Get-NetAdapter).InterfaceAlias } -Credential $cred
    # New-NetIPAddress -InterfaceIndex 2 -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
}
catch {
    
}
