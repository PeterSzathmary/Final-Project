<#
.SYNOPSIS
    Adds new DNS records for mail server
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Add-DNSRecords -DomainName "windows.lab" -IPv4OfDNS "10.0.0.1" -NetID "10.0.0.0/24"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Add-DNSRecords {
    [CmdletBinding()]
    param (
        # domain name
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $DomainName,

        # ipv4 address of DNS server resource record A
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $IPv4OfDNS,

        # network ID
        [Parameter(
            Position = 2,
            Mandatory = $true
        )]
        [string]
        $NetID
    )
    
    begin {
        $Flag = "dns_configured"
        if (Test-Path "C:\$Flag") {
            Write-Host "DNS already configured" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            # 1. create record A (@) point to IP server
            Add-DnsServerResourceRecordA -Name "mail" -ZoneName $DomainName -IPv4Address $IPv4OfDNS
            # MX record
            Add-DnsServerResourceRecordMX -Preference 10  -Name $DomainName -MailExchange "mail.$DomainName" -ZoneName $DomainName
            # add reverse lookup zone primary
            Add-DnsServerPrimaryZone -NetworkID $NetID -ReplicationScope "Forest"
            # reverse PTR records
            # TODO: fix (it doesn't set correct Name in DNS like this: 10.0.0.1)
            # Add-DnsServerResourceRecordPtr -Name "10" -ZoneName "0.0.10.in-addr.arpa" -PtrDomainName "WIN-DC-001.windows.lab"
            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "DNS successfully configured" -ForegroundColor Green
        }
    }
}#Add-DNSRecords