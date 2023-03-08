<#
.SYNOPSIS
    Creates new OU in the domain
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    New-OU -Name "Students"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function New-OU {
    [CmdletBinding()]
    param (
        # organization unit name
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $Name
    )
    
    begin {
        $Flag = "ou_students_created"
        if (Test-Path "C:\$Flag") {
            Write-Host "OU $Name already created" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $forest = Get-ADDomain | Select-Object -ExpandProperty Forest
            $arr = $forest.Split(".")

            New-ADOrganizationalUnit -Name $Name -Path "DC=$($arr[0].ToUpper()),DC=$($arr[1].ToUpper())" -ProtectedFromAccidentalDeletion $false

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "OU $Name successfully created" -ForegroundColor Green
        }
    }
}#New-OU