<#
.SYNOPSIS
    Enables AD Recycle bin
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Enable-ADRecycleBin -Domain "windows.lab"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Enable-ADRecycleBin {
    [CmdletBinding()]
    param (
        # domain name
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $Domain
    )
    
    begin {
        $Flag = "ad_recycle_bin_enabled"
        if (Test-Path "C:\$Flag") {
            Write-Host "AD Recycle bin already enabled" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $computerName = hostname.exe

            Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target $Domain -Server $computerName -Confirm:$false

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "AD Recycle bin successfully enabled" -ForegroundColor Green
        }
    }
}#Enable-ADRecycleBin