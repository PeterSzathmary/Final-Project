<#
.SYNOPSIS
    Downloads Oracle Enterprise edition from the internet.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Get-OracleEnterpriseDB
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Get-OracleEnterpriseDB {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "oracle_enterprise_downloaded"
        if (Test-Path "C:\$Flag") {
            Write-Host "Oracle Enterprise already downloaded" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $p = "C:\tools\selenium"
            Import-Module "$($p)\WebDriver.dll"

            $chromeOptions = [OpenQA.Selenium.Chrome.ChromeOptions]::new()
            $chromeOptions.AddArgument("start-maximized")
            $chromeOptions.AddArgument("incognito")
            $chromeOptions.AddArgument("headlesss")
            $chromeOptions.AddArgument("disable-gpu")


            $chromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver -ArgumentList $chromeOptions
            $chromeDriver.Url = "https://www.oracle.com/database/technologies/oracle-database-software-downloads.html"

            #$iframe = '/html/body/div[5]/div/iframe'

            Start-Sleep 10

            $chromeDriver.SwitchTo().Frame(1)

            Start-Sleep 5

            $acceptAll = "/html/body/div[8]/div[1]/div/div[3]/a[1]"

            $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($acceptAll)).Click()

            Start-Sleep 5

            $chromeDriver.SwitchTo().ParentFrame()
            Start-Sleep 10

            #$downloadZIP = "/html/body/div[2]/section[3]/div/div[1]/div/table/tbody/tr/td[2]/div/a"
            # Windows x64 zip
            $downloadZIP = "/html/body/div[2]/section[3]/div/div[2]/div/table/tbody/tr[1]/td[2]/div/a"

            $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($downloadZIP)).Click()

            Start-Sleep 5

            $checkbox = "/html/body/div[7]/div/div[1]/div/div/div/form/ul/li/label/input"

            $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($checkbox)).Click()

            Start-Sleep 5

            $download = "/html/body/div[7]/div/div[1]/div/div/div/form/div/div[2]/div/div/a"

            $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($download)).Click()

            Start-Sleep 5

            $email = "//*[@id='sso_username']"
            $password = '//*[@id="ssopassword"]'
            $signin = '//*[@id="signin_button"]'
            $emailToDownload = Read-Host "Email"
            $passwordToDownload = Read-Host "Password" -AsSecureString

            $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($email)).SendKeys($emailToDownload)

            Start-Sleep 5

            $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($password)).SendKeys([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordToDownload)))

            Start-Sleep 5

            $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($signin)).Click()

            Start-Sleep 5

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Oracle Enterprise successfully downloaded" -ForegroundColor Green
        }
    }
}#Get-OracleEnterpriseDB