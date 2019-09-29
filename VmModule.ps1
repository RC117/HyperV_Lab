# TODO
# create a diff disk for each vm
# create a vm connecting to that new diff disk

<#
.SYNOPSIS
Removes the VM and attached VHDs
#>
Function Remove-VMAndVHD {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VmName
    )
    # Remove VM and it's VHDs
    try {
        $VM = Get-VM -VMName $VmName -ErrorAction SilentlyContinue

        if ($Null -ne $VM) {
            $vmvhds = $VM | Select-Object VMId | Get-VHD
            Stop-VM -VMName $VmName -Force
            Remove-VM -VMName $VmName -Force
            $vmvhds | ForEach-Object { Remove-Item -Path $_.ParentPath -Recurse -Force -Confirm:$false }
        }
    }
    catch {
        Throw "The VM does not exist"
    }
}

<#
.SYNOPSIS
Create the VM 
#>
Function Add-DiffVm {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VmName,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$ParentPath,
        [Parameter(Mandatory = $true)]
        [string]$SwitchName
    )

    $VhdFullPath = "$($Path)\$($VmName)Diff.vhdx"

    write-host "$($ParentPath)"

    # Create diff disk
    try {
        New-VHD -Path $VhdFullPath -ParentPath "$($ParentPath)" -Differencing
    }
    Catch {
        Throw "The Hard disk could not be created"
    }

    # create vm using new diff disk
    try {
        New-VM -Name $VmName -Generation 2 -MemoryStartupBytes 3072MB -VHDPath $VhdFullPath -SwitchName $SwitchName   
    }
    Catch {
        Throw "The VM could not be created"
    }

}

# # Start VM
# try {
#     Start-VM -Name Test1
#     Enable-VMIntegrationService -VMName Test1 -Name "Guest Service Interface"
#     # Invoke-Command -VMName Test1 -ScriptBlock { (Get-NetAdapter).InterfaceAlias } -Credential $cred
#     # Get-VM Test1 | Add-VMNetworkAdapter -SwitchName Internet        
# }
# catch {
#     Throw "Could not start VM"
# }



# TODO: get network adapter and then change it's ip
# TODO: Then add "Internet" as new network adapter

# try {
#     # Invoke-Command -VMName Test1 -ScriptBlock { (Get-NetAdapter).InterfaceAlias } -Credential $cred
#     # New-NetIPAddress -InterfaceIndex 2 -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
# }
# catch {
    
# }
