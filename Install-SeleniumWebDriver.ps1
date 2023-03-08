<#
.SYNOPSIS
    Installs Selenium web driver.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-SeleniumWebDriver
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Install-SeleniumWebDriver {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "selenium_webdriver_dll_downloaded"
        if (Test-Path "C:\$Flag") {
            Write-Host "Selenium web driver already installed." -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $url = "https://www.nuget.org/api/v2/package/Selenium.WebDriver/4.5.1"
            $out = "C:\Users\Administrator\Downloads\selenium_webdriver.zip"

            Invoke-WebRequest -Uri $url -OutFile $out
            Expand-Archive "C:\Users\Administrator\Downloads\selenium_webdriver.zip" -DestinationPath "C:\Users\Administrator\Downloads\selenium_webdriver"

            Copy-Item -Path "C:\Users\Administrator\Downloads\selenium_webdriver\lib\net48\WebDriver.dll" -Destination "C:\tools\selenium"

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Selenium web driver successfully installed." -ForegroundColor Green
        }
    }
}#Install-SeleniumWebDriver