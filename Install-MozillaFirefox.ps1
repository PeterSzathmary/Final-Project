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
    Install-MozillaFirefox -SleepTime 35
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-MozillaFirefox {
    [CmdletBinding()]
    param (
        # sleep time
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $SleepTime
    )
    
    begin {
        if (Test-Path "C:\firefox_installed") {
            Write-Host "Firefox already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $workdir = "C:\installer\"
    
            if (Test-Path -Path $workdir -PathType Container) {
                Write-Host "$workdir already exists" -ForegroundColor Red
            }
            else {
                New-Item -Path $workdir  -ItemType directory
            }
    
            $source = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
            $destination = "$workdir\firefox.exe"
    
            if (Get-Command 'Invoke-WebRequest') {
                Write-Host "Downloading Mozilla Firefox..."
                Invoke-WebRequest $source -OutFile $destination
            }
            else {
                $WebClient = New-Object System.Net.WebClient
                $webclient.DownloadFile($source, $destination)
            }
    
            Start-Process -FilePath "$workdir\firefox.exe" -ArgumentList "/S"
    
            Start-Sleep -s $SleepTime
    
            Remove-Item -Force $workdir/firefox*
            Remove-Item "C:\installer"
    
            New-Item -Path "C:\" -Name "firefox_installed" -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Firefox installed successfully." -ForegroundColor Green
        }
    }
}#Install-MozillaFirefox