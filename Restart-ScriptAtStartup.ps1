<#
.SYNOPSIS
    Add restart flag to registry.
.DESCRIPTION
    Add restart flag to registry which will ensure that the script will start after every login.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Restart-ScriptAtStartup -Path "absolute_path_to_script_file"

    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Restart-ScriptAtStartup {
    [CmdletBinding()]
    param (
        # # Path to script
        # [Parameter(
        #     Position = 0,
        #     Mandatory = $true
        # )]
        # [string]
        # $Path
    )
    
    begin {
        # test if the subkey MyFlags doesn't exist in SOFTWARE subkey
        if (!(Test-Path -Path "HKLM:\SOFTWARE\MyFlags")) {
            # create one if it doesn't exist
            New-Item -Path "HKLM:\SOFTWARE" -Name "MyFlags"
        }
        #it exists, so skip creating subkey MyFlags
        else {
            # get the subkey
            $Key = Get-Item -LiteralPath "HKLM:\SOFTWARE\MyFlags"

            if ($null -eq $Key.GetValue("StartAtLogon", $null)) {
                New-ItemProperty -Path "HKLM:\Software\MyFlags" -Name "StartAtLogon" -Value 1
            }
            else {
                Write-Host "Flag is already created." -ForegroundColor Yellow
                $Skip = $True
            }
        }

        
    }
    
    process {
        if ($Skip -ne $true) {
            $PathToScript = Read-Host "Path to script that will start at every startup"
            New-Item `
                -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" `
                -Name "startup.cmd" `
                -ItemType "file" `
                -Value "start powershell -noexit -file $PathToScript"

                $Skip = $true
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Flag for starting up the script successfully created." -ForegroundColor Green
        }
    }
}#Restart-ScriptAtStartup