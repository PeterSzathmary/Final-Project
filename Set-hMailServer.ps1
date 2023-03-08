<#
.SYNOPSIS
    Configures hMailServer
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Set-hMailServer -DomainName "windows.lab" -SMTPBindToIP "10.0.0.1"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Set-hMailServer {
    [CmdletBinding()]
    param (
        # domain name
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $DomainName,

        # SMTP delivery to IP
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $SMTPBindToIP
    )
    
    begin {
        $Flag = "hMailServer_configured"
        if (Test-Path "C:\$Flag") {
            Write-Host "hMailServer already configured" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            Start-Sleep 35
            # add domain: windows.lab
            #$hMSAdminPass = "Start123"
            $hMS = New-Object -COMObject hMailServer.Application
            Try {
                $hMS.Authenticate("Administrator", "") | Out-Null
                $hMSAddDomain = $hMS.Domains.Add()
                $hMSAddDomain.Name = $DomainName
                $hMSAddDomain.Active = $True
                $hMSAddDomain.Save()
            }
            Catch {
                Write-Host "Authentication failed."
            }

            # add accounts:
            $wlab = $hMS.Domains.ItemByName($DomainName)

            # add administrator
            #cscript.exe C:\Users\Administrator\Desktop\Configure_hMailServer.vbs
            $newAccount = $wlab.Accounts.Add()
            $newAccount.Address = "administrator@$DomainName"
            #$newAccount.Password = 
            $newAccount.IsAD = $True
            $newAccount.ADUsername = "administrator"
            $newAccount.ADDomain = $DomainName
            $newAccount.AdminLevel = 0 # 0 - User 1 - Domain 2 - Server
            $newAccount.Active = $True
            $newAccount.MaxSize = 10
            $newAccount.UnlockMailbox()
            $newAccount.Save()

            # get all AD students to array
            $students = Get-ADUser -Filter * -SearchBase "OU=STUDENTS,DC=WINDOWS,DC=LAB" | Select-Object -Property Name, UserPrincipalName, SamAccountName

            foreach ($s in $students) {
                $newAccount = $wlab.Accounts.Add()
                $newAccount.Address = $s.SamAccountName + "@$DomainName"
                #$newAccount.Password = 
                $newAccount.IsAD = $True
                $newAccount.ADUsername = $s.SamAccountName
                $newAccount.ADDomain = $DomainName
                $newAccount.AdminLevel = 0 # 0 - User 1 - Domain 2 - Server
                $newAccount.Active = $True
                $newAccount.MaxSize = 10
                $newAccount.Save()
            }

            # settings: protocols: check all
            $hMS.Settings.ServiceIMAP = $True
            $hMS.Settings.ServicePOP3 = $True
            $hMS.Settings.ServiceSMTP = $True

            # settings: protocols: smtp: delivery of e-mail: set local host name to "windows.lab"
            $hMS.Settings.HostName = $DomainName

            # settings: protocols: smtp: rfc check all -> advanced: bind to local ip (ip of server 10.0.0.1)
            $hMs.Settings.SMTPDeliveryBindToIP = $SMTPBindToIP

            # logging: enabled and check all (not keep files open)
            $hMS.Settings.Logging.Enabled = $True
            $hMS.Settings.Logging.LogApplication = $True
            $hMS.Settings.Logging.LogSMTP = $True
            $hMS.Settings.Logging.LogPOP3 = $True
            $hMS.Settings.Logging.LogIMAP = $True
            $hMS.Settings.Logging.LogTCPIP = $True
            $hMS.Settings.Logging.LogDebug = $True
            $hMS.Settings.Logging.AWStatsEnabled = $True

            # advanced: ip ranges: my computer: allow ALL connections, requires smtp all local, allow deliveries uncheck last

            # advanced: ip ranges: internet:    ----------------------------||-----------------------------------------------

            # TCP/IP ports keep 25 110 143 (all else delete)

            # utilities: set backup destination

            # run diagnostics

            New-Item -Path "C:\" -Name "hMailServer_configured" -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "hMailServer successfully configured" -ForegroundColor Yellow
        }
    }
}#Set-hMailServer