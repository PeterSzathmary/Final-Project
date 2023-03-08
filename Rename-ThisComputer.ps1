<#
.SYNOPSIS
    Renames the computer.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Rename-ThisComputer -ComputerName "WIN10"
    
    Renames the computer to WIN10
#>


function Rename-ThisComputer {
    [CmdletBinding()]
    param (
        # new name for computer
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $ComputerName
    )
    
    begin {
        $Flag = "computer_renamed"
        if (Test-Path "C:\$Flag") {
            Write-Host "Computer is already renamed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            New-Item -Path "C:\" -Name $Flag -ItemType File
    
            Start-Sleep -Seconds 5

            Rename-Computer -NewName $ComputerName -Restart
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Computer renamed successfully." -ForegroundColor Green
        }
    }
}#Rename-ThisComputer