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
    Deploy-ORA_ErrorsExplanations
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Deploy-ORA_ErrorsExplanations {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        sqlplus.exe / as sysdba "@C:\Users\Administrator\Desktop\Final-Project\SQL\master.sql"

        $file = "C:\users_sperrorlogs.csv"

        (Get-Content $file | Select-Object -Skip 1) | Set-Content $file

        $sperrorlogs = Import-Csv -Path $file

        foreach ($sperrorlog in $sperrorlogs) {

            $errorPathFile = "C:\$($sperrorlog.owner.ToLower())_errors.txt"

            if (Test-Path $errorPathFile) {
                Clear-Content $errorPathFile
            }

            Add-Content -Path $errorPathFile "$($sperrorlog.owner) errors : "
    
            sqlplus.exe / as sysdba "@C:\Users\Administrator\Desktop\Final-Project\SQL\show_ora_msgs.sql" "'$($errorPathFile)'" "'$($sperrorlog.owner.ToLower()).sperrorlog'"

            if (Test-Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt") {
                Clear-Content "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt"
            }

            Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" "BE CAREFUL FOR THESE ERRORS : `n"
            
            $fileLinesArray = get-content $errorPathFile -ReadCount 10000

            $ORA_lines = @()
            $sql_statements = @()
            
            for ($id=0; $id -lt $fileLinesArray.Length; $id++){
              
                if ($fileLinesArray[$id] -match "ORA-") {
                    $ORA_lines += $fileLinesArray[$id]
                    $sql_statements += "statement: $($fileLinesArray[$id + 1])"

                }
            }

            for ($id=0; $id -lt $ORA_lines.Length; $id++) {

                $pos = $ORA_lines[$id].IndexOf(":")
                $leftPart = $ORA_lines[$id].Substring(0, $pos)

                $ORA_number = $leftPart.Replace("ORA-", "")

                Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" $ORA_lines[$id]
                Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" $sql_statements[$id]
                Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" $(oerr ora $ORA_number)
                Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" ""
            }

            Send-Mail -To "$($sperrorlog.owner.ToLower())@windows.lab" -From "Administrator <administrator@windows.lab>" -Subject "ORA Errors & Explanations" -Attachments "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt"
        }
    }
    
    process {
        
    }
    
    end {
        
    }
}#Deploy-ORA_ErrorsExplanations

Deploy-ORA_ErrorsExplanations