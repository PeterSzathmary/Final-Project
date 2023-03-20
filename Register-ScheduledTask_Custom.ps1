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
    Register-ScheduledTask_Custom -PathToScript "C:\script.ps1" -TaskName "Some Script Name" -At "11:30pm" -Description "some description"

    Every sunday at 1:00
    Register-ScheduledTask_Custom -PathToScript "$env:UserProfile\Desktop\Final-Project\Oracle-Monitoring\Start-OracleBackup.ps1" -TaskName 'Oracle Incremental Backup RMAN 1130pm' -At "11:30pm" -Description "It starts incremental backup." -Day "Sunday"

    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Register-ScheduledTask_Custom {
    [CmdletBinding()]
    param (
        # path to script to register
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $PathToScript,

        # name of the task
        # cannot contain ":"
        # add validation for it
        [Parameter(Position = 1, Mandatory = $true)]
        [string]
        $TaskName,

        # when to run the task
        [Parameter(Position = 2, Mandatory = $true)]
        [datetime]
        $At,

        # description of the task
        [Parameter(Position = 3, Mandatory = $false)]
        [string]
        $Description,

        # what day? if not specified, it will use daily
        [Parameter(Position = 4, Mandatory = $false)]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [string]
        $Day
    )
    
    begin {
        $taskExists = Get-ScheduledTask | Where-Object { $_.TaskName -like $TaskName }
    }
    
    process {
        if ($taskExists) {
            Write-Host "$TaskName already exists!" -ForegroundColor Yellow
        }
        else {
            $Action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument $PathToScript
            if ($Day) {
                $Trigger = New-ScheduledTaskTrigger -Weekly -At $At -WeeksInterval 1 -DaysOfWeek $Day
            }
            else {
                $Trigger = New-ScheduledTaskTrigger -Daily -At $At
            }
            Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $TaskName -Description $Description
        }
    }
    
    end {
        
    }
}#Register-ScheduledTask_Custom