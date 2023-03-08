<#
.SYNOPSIS
    Downloads hMailServer from the internet.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Get-hMailServer
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Get-hMailServer {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "hMailServer_downloaded"
        if (Test-Path "C:\$Flag") {
            Write-Host "hMailServer already downloaded" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $url = "https://www.hmailserver.com/files/hMailServer-5.6.8-B2574.exe"
            $output = "C:\Users\Administrator\Downloads\hMailServer_setup.exe"
            $start_time = Get-Date

            Invoke-WebRequest -Uri $url -OutFile $output

            Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "hMailServer successfully downloaded" -ForegroundColor Green
        }
    }
}#Get-hMailServer