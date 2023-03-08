<#
.SYNOPSIS
    Downloads Mozilla Thunderbird from the internet
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Get-MozillaThunderbird
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Get-MozillaThunderbird {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "mozillaThunderbird_downloaded"
        if (Test-Path "C:\$Flag") {
            Write-Host "Mozilla Thunderbird already downloaded" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $url = "https://download.mozilla.org/?product=thunderbird-102.6.1-SSL&os=win64&lang=en-US"
            $output = "$env:UserProfile\Downloads\mozillaThunderbird.exe"
            $start_time = Get-Date

            Invoke-WebRequest -Uri $url -OutFile $output

            Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Mozilla Thunderbird successfully downloaded" -ForegroundColor Yellow
        }
    }
}#Get-MozillaThunderbird