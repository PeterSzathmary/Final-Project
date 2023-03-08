<#
.SYNOPSIS
    Installs Chrome driver with Choco
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-ChromeDriver
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-ChromeDriver {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "chrome_driver_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "Chrome driver already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            choco install selenium-chrome-driver --force -y # c:\tools\selenium
            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Chrome driver successfully installed" -ForegroundColor Green
        }
    }
}#Install-ChromeDriver