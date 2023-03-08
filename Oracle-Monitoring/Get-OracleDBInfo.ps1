function Get-OracleDBInfo {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        $ScriptPath = "output.sql"
        $Container = "CDB`$ROOT"
        $TXTPath = "test.txt"
        $SQLInfoPath = "tablespaces_info.sql"

        if (!(Test-Path "C:\DB\$TXTPath")) {
            New-Item -Path "C:\DB\$TXTPath" -Force
        }

        Add-Content "C:\DB\$TXTPath" "`n$Container tablespaces usage information: "
        sqlplus.exe / as sysdba "@$ScriptPath" $Container $TXTPath $SQLInfoPathŁ
    }
    
    end {
        
    }
}#Get-OracleDBInfo