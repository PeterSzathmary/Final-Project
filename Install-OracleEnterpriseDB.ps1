<#
.SYNOPSIS
    Installs Oracle Enterprise DB
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-OracleEnterpriseDB
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-OracleEnterpriseDB {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "oracle_enterprise_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "Oracle Enterprise DB already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $oracleDBProductPath = "C:\app\19c\product"
            $oracleDBBasePath = "C:\app\19c\base"

            New-Item -ItemType Directory -Force -Path $oracleDBProductPath
            New-Item -ItemType Directory -Force -Path $oracleDBBasePath

            #extract archive to c -> app -> 19c -> product
            if (!(Test-Path "C:\oracle_enterprise_expanded")) {
                Write-Host -ForegroundColor Magenta "Wait until the download process of Oracle DB is finished. Start Expanding? Press ENTER to continue... " -NoNewline
                Read-Host
                Write-Host "Expanding..." -ForegroundColor Cyan
                Expand-Archive "C:\Users\Administrator\Downloads\WINDOWS.X64_193000_db_home.zip" -DestinationPath $oracleDBProductPath

                New-Item -Path "C:\oracle_enterprise_expanded" -ItemType File
            }

            #C:\app\19c\product\bin to path # should be already there

            #C:\app\19c\product\setup.exe /s /v"RSP_FILE=C:\Users\Administrator\Desktop\db.rsp" /v"/L*v C:\Users\Administrator\Desktop\setup.log" /v"/qn"
            $DBResponseFilePath = Read-Host "Path to Oracle response file"
            if (Test-Path $DBResponseFilePath) {
                C:\app\19c\product\setup.exe -silent -responseFile $DBResponseFilePath
                New-Item -Path "C:\" -Name $Flag -ItemType File
            }
            else {
                Write-Host "Response file is not FOUND!" -ForegroundColor Red
                Start-Sleep -Seconds 10
            }

            # set ORACLE_HOME
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Oracle Enterprise DB successfully installed" -ForegroundColor Yellow
        }
    }
}#Install-OracleEnterpriseDB