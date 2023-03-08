<#
.SYNOPSIS
    Installs 7Zip
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-7Zip
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-7Zip {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "7zip_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "7Zip is already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe") } | Select-Object -First 1 | Select-Object -ExpandProperty href)
            # modified to work without IE
            # above code from: https://perplexity.nl/windows-powershell/installing-or-updating-7-zip-using-powershell/
            $installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
            Invoke-WebRequest $dlurl -OutFile $installerPath
            Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
            Remove-Item $installerPath

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "7Zip installed successfully" -ForegroundColor Green
        }
    }
}#Install-7Zip