<#
.SYNOPSIS
    Disable maps broker service.
.DESCRIPTION
    What is Windows MapsBroker?
    Maps. Some map apps, such as Windows Maps, depend on the Downloaded Maps Manager service,
    also known as MapsBroker. If you download offline maps, this service runs in the background to keep
    them up to date. Because it only runs occasionally, it consumes very few system resources.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Disable-MapsBroker
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Disable-MapsBroker {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        if (Test-Path "C:\maps_broker_disabled") {
            Write-Host "MapsBroker already disabled." -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            Get-Service -Name MapsBroker | Set-Service -StartupType Disabled -Confirm:$false
            Write-Host "Turning off maps broker..."
            New-Item -Path "C:\" -Name "maps_broker_disabled" -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "MapsBroker successfully disabled." -ForegroundColor Green
        }
    }
}#Disable-MapsBroker