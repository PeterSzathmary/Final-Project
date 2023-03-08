<#
.SYNOPSIS
    Installs Chocolatey
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-Chocolatey
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-Chocolatey {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "chocolatey_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "Chocolatey already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Chocolatey installed successfully" -ForegroundColor Green
        }
    }
}#Install-Chocolatey