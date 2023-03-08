<#
.SYNOPSIS
    Installs Active Directory Domain Services
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-ADDS
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-ADDS {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "adds_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "AD DS already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "AD DS successfully installed" -ForegroundColor Yellow
        }
    }
}#Install-ADDS