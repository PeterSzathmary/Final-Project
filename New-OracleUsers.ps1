<#
.SYNOPSIS
    Creates new Oracle users.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
    Creates new users and set their default tablespace and quota unlimited on their tablespaces.
.NOTES
    Connection string with the new user: connect <=user_name=>/<=user_name=>123@localhost:1521/orclpdb.windows.lab
.LINK
    https://www.oracletutorial.com/oracle-administration/oracle-create-tablespace/
.EXAMPLE
    New-OracleUsers -Users $UsersArray
    
    Creates new users for every element in the array and set their password to <=USER_NAME=>*123
#>

function New-OracleUsers {
    [CmdletBinding()]
    param (
        # Array of users we want to create in database
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string[]]
        $Users
    )
    
    begin {
        $Path = "C:\SQL Scripts\create_users.sql"
        # Create the file if it doesn't exist
        if (!(Test-Path $Path)) {
            New-Item -Path $Path -Force
        }
    }
    
    process {
        Clear-Content $Path

        # Switch to pluggable container
        Add-Content $Path "`nALTER SESSION SET CONTAINER = orclpdb;"

        foreach ($User in $Users) {
            Add-Content $Path "`nCREATE USER $User IDENTIFIED BY $($User)123 DEFAULT TABLESPACE $User QUOTA UNLIMITED ON $User;"
            Add-Content $Path "`nGRANT CREATE SESSION TO $User;"
            Add-Content $Path "`nGRANT CREATE TABLE TO $User;"
        }

        # Exit from SQL*Plus
        Add-Content $Path "`nexit"

        sqlplus.exe '/ as sysdba' "@$Path"
    }
    
    end {
        Write-Host "Users successfully created" -ForegroundColor Green
    }
}#New-OracleUsers