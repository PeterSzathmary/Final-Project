<#
.SYNOPSIS
    Sets static IP.
.DESCRIPTION
    We can choose which interface we want to configure.
    It will also set primary DNS to itself and secondary DNS to empty.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Set-StaticIP -StaticIP "10.0.0.1"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Set-StaticIP {
    [CmdletBinding()]
    param (
        # static IP
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $StaticIP
    )
    
    begin {
        if (Test-Path "C:\static_ip") {
            Write-Host "Static IP already configured." -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            Get-NetIPConfiguration

            $width = [Console]::WindowWidth
            Write-Host ("-" * $width + "`n")

            Write-Host "Please enter below which interface you want to configure"
            $interfaceIndex = Read-Host "Choose the interface index (-1 for exit)"

            if ($interfaceIndex -ne -1) {
                $ip = $StaticIP
                $primaryDNS = $StaticIP
                $secondaryDNS = ""
    
                Start-Sleep 3
                #Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceIndex 10).InterfaceGuid)" -Name EnableDHCP -Value 0
                New-NetIPAddress -IPAddress $ip -PrefixLength 24 -InterfaceIndex $interfaceIndex

                Start-Sleep 3
                Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($primaryDNS, $secondaryDNS)
            }
    
            New-Item -Path "C:\" -Name "static_ip" -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Static IP configured successfully." -ForegroundColor Green
        }
    }
}#Set-StaticIP