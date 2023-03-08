<#
.SYNOPSIS
    Installs NET Framework Core
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-NETFramework
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-NETFramework {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "netFrameWork_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "NET Framework Core already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            Install-WindowsFeature Net-Framework-Core

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "NET Framework Core successfully installed" -ForegroundColor Green
        }
    }
}#Install-NETFramework