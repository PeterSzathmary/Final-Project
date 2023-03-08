<#
.SYNOPSIS
    Installs hMailServer
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-hMailServer
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-hMailServer {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "hMailServer_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "hMailServer already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            #Start-Process -FilePath "C:\Users\Administrator\Downloads\hMailServer_setup.exe" -Verb RunAs -ArgumentList "/verysilent","/password=$hMailAdminPassword" -PassThru -NoNewWindow -Wait
            C:\Users\Administrator\Downloads\hMailServer_setup.exe /silent
            #Invoke-Command -ScriptBlock $pathvargs

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "hMailServer successfully installed" -ForegroundColor Green
        }
    }
}#Install-hMailServer