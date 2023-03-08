<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Unblock-Port -Direction "Inbound" -Port 1521
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Unblock-Port {
    [CmdletBinding()]
    param (
        # direction
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [ValidateSet("Inbound", "Outbound")]
        [string]
        $Direction,

        # port to unblock
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $Port
    )
    
    begin {
        $flag = "allow_$($Port)_$Direction"
        if (Test-Path "C:\$flag") {
            Write-Host "Port $Port already unblocked in $Direction direction." -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            New-NetFirewallRule -DisplayName "Allow $Direction Port $Port" -Direction $Direction -LocalPort $Port -Protocol TCP -Action Allow

            New-Item -Path "C:\" -Name $flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Port $Port successfully enabled." -ForegroundColor Green
        }
    }
}#Unblock-Port