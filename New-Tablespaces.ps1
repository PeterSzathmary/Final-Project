<#
.SYNOPSIS
    Creates new tablespaces for users.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
    Creates new tablespaces for users in the array what we will pass. But only
    if they don't exists.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    https://www.oracletutorial.com/oracle-administration/oracle-create-tablespace/
.EXAMPLE
    New-Tablespaces -Users $UsersArray -TablespaceSize "10M"
    
    Creates tablespaces for every user in the array with the datafile size of 10M
#>
function New-Tablespaces {
    [CmdletBinding()]
    param (
        # Users to which we are going to create tablespaces.
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string[]]
        $Users,

        # Tablespace size
        [Parameter(
            Position = 1,
            Mandatory = $true
            
        )]
        # TODO validate input size with regex
        #[ValidatePattern(<regex here>)]
        [string]
        $TablespaceSize
    )
    
    begin {
        $Path = "C:\SQL Scripts\create_tablespaces.sql"
        New-Item -Path $Path -Force
    }
    
    process {
        Clear-Content $Path

        # Switch to pluggable container
        Add-Content $Path "`nALTER SESSION SET CONTAINER = orclpdb;"

        foreach ($User in $Users) {
            Add-Content $Path "`nCREATE TABLESPACE $User DATAFILE '$($User)_data.dbf' SIZE $TablespaceSize;"
        }

        # Exit from SQL*Plus
        Add-Content $Path "`nexit"

        sqlplus.exe '/ as sysdba' "@$Path"
    }
    
    end {
        Write-Host "Tablespaces successfully created" -ForegroundColor Green
    }
}#New-Tablespaces