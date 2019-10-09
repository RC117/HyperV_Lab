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
            do {
                $vm = Get-VM -VMName $VmName
            } while ($vm.Heartbeat -eq "OkApplicationsHealthy")
            
            Remove-VM -VMName $VmName -Force
            $vmvhds | ForEach-Object { 
                write-host $_.Path
                Remove-Item -Path $_.Path -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
            }
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
        # TODO: try taking this off? -ErrorAction SilentlyContinue
        New-VHD -Path $VhdFullPath -ParentPath "$($ParentPath)" -Differencing -ErrorAction SilentlyContinue
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

<#
.SYNOPSIS
Update Ip Address
#>
Function Update-IP {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VmName,
        [Parameter(Mandatory = $true)]
        [string]$IpAddress,
        [Parameter(Mandatory = $true)]
        [string]$DefaultGateway
    )

    Write-Host "****** UPDATE-IP *******"
    Write-Host $IpAddress
    Write-Host $DefaultGateway

    Enable-VMIntegrationService -VMName $VmName -Name "Guest Service Interface"

    Start-VM -VMName $VmName
    do {
        $vm = Get-VM -VMName $VmName
    } while ($vm.Heartbeat -ne "OkApplicationsHealthy")

    $managedCred = Get-StoredCredential -Target MyVMs # Create "Generic credential" in Credential Manager in Windows
    Invoke-Command -VMName $VmName -ScriptBlock { 
        # (New-NetIPAddress -IPAddress $args[0] -DefaultGateway $args[1] -PrefixLength 24 -AddressFamily IPv4 -InterfaceIndex (Get-NetAdapter).InterfaceIndex)
        (New-NetIPAddress -IPAddress $args[0] -PrefixLength 24 -AddressFamily IPv4 -InterfaceIndex (Get-NetAdapter).InterfaceIndex) 
    } -Credential $managedCred -ArgumentList $IpAddress, $DefaultGateway
}