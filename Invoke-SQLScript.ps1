<#
.SYNOPSIS
    Invoke SQL script at given path.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE

    With container name

    Invoke-SQLScript -PathToSql "$env:UserProfile\Desktop\Final-Project\SQL\tablespaces_info.sql" -FullLogPath "C:\tablespaces_log_$(Get-Date -Format "dd-MM-yyyy-HH-mm-ss").txt" -Container "orclpdb"

    Withouth container name

    Invoke-SQLScript -PathToSql "$env:UserProfile\Desktop\Final-Project\SQL\tablespaces_info.sql" -FullLogPath "C:\tablespaces_log_$(Get-Date -Format "dd-MM-yyyy-HH-mm-ss").txt"

    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Invoke-SQLScript {
    [CmdletBinding()]
    param (
        # path to the sql script
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $PathToSql,

        # full path of log destination file
        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
        [string]
        $FullLogPath,

        # name of the contaienr to use
        [Parameter(
            Position = 2,
            Mandatory = $false
        )]
        [string]
        $ContainerName = "CDB`$ROOT"
    )
    
    begin {
        
    }
    
    process {
        if ($FullLogPath) {
            sqlplus.exe / as sysdba "@$PathToSql" "'$FullLogPath'" "'$ContainerName'"
        }
        else {
            sqlplus.exe / as sysdba "@$PathToSql"
        }
    }
    
    end {
        
    }
}#Invoke-SQLScript