<#
.SYNOPSIS
    Install DHCP
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-DHCP -Domain "windows.lab" -StaticIP "10.0.0.1" -DHCPscope $DHCPScope::class
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-DHCP {
    [CmdletBinding()]
    param (
        # domain name
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $Domain,

        # static IP of the server
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $StaticIP,

        # dhcp scope
        [Parameter(
            Position = 2,
            Mandatory = $true
        )]
        [object]
        $DHCPscope
    )
    
    begin {
        $Flag = "dhcp_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "DHCP already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            Install-WindowsFeature DHCP -IncludeManagementTools
            Add-DhcpServerInDC -DnsName $Domain -IPAddress $StaticIP
            Add-DhcpServerSecurityGroup
            Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
            Restart-Service -Name DHCPServer -Force

            # Configuration
            Import-Module DHCPServer
            # Create new inactive scope
            Add-DhcpServerv4Scope -Name $DHCPscope.Name -StartRange $DHCPscope.StartRange -EndRange $DHCPscope.EndRange -SubnetMask $DHCPscope.SubnetMask -State InActive
            Set-DhcpServerv4OptionValue -ScopeID $DHCPscope.ScopeID -DnsDomain $Domain -DnsServer $DHCPscope.DnsServer # -Router 192.168.113.1
            # Activate
            Set-DhcpServerv4Scope -ScopeID $DHCPscope.ScopeID -State Active

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "DHCP successfully installed" -ForegroundColor Green
        }
    }
}#Install-DHCP