<#
.SYNOPSIS
    Creates new group in AD
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    New-ADGroup_Custom -GroupName "SWOT Developers" -GroupDescription "Members of this group are SWOT Developers"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function New-ADGroup_Custom {
    [CmdletBinding()]
    param (
        # new name for a AD group
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $GroupName,

        # group name description
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $GroupDescription
    )
    
    begin {
        $Flag = "ad_group_$($GroupName)_created"
        if (Test-Path "C:\$Flag") {
            Write-Host "AD group $GroupName already created" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $forest = Get-ADDomain | Select-Object -ExpandProperty Forest
            $arr = $forest.Split(".")
        
            New-ADGroup `
                -Name $GroupName `
                -SamAccountName $GroupName `
                -GroupCategory Security `
                -GroupScope Global `
                -DisplayName $GroupName `
                -Path "CN=Users,DC=$($arr[0]),DC=$($arr[1])" `
                -Description $GroupDescription

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "AD group $GroupName succcessfully created" -ForegroundColor Green
        }
    }
}#New-ADGroup_Custom