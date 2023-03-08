class DHCPScope {
    [string] $Name
    [ipaddress] $StartRange
    [ipaddress] $EndRange
    [ipaddress] $SubnetMask
    [ipaddress] $ScopeID
    [ipaddress] $DnsServer

    DHCPScope(
        [string] $Name,
        [ipaddress] $StartRange,
        [ipaddress] $EndRange,
        [ipaddress] $SubnetMask,
        [ipaddress] $ScopeID,
        [ipaddress] $DnsServer
    ) {
        $this.Name = $Name
        $this.StartRange = $StartRange
        $this.EndRange = $EndRange
        $this.SubnetMask = $SubnetMask
        $this.ScopeID = $ScopeID
        $this.DnsServer = $DnsServer
    }
}

# Add every *.ps1 file to PowerShell profile, except $excluded array
if (!(Test-Path $profile)) {
    New-Item -Path $profile -Force
    $config = (Get-Content "C:\Users\Administrator\Desktop\Final-Project\config.json" -Raw) | ConvertFrom-Json
    Get-ChildItem ".\" -recurse | Where-Object { $_.Name -eq "config.json" } | ForEach-Object {
        Write-Host $_.FullName
        Add-Content $profile "`$config = (Get-Content `"C:\Users\Administrator\Desktop\Final-Project\config.json`" -Raw) | ConvertFrom-Json"
    }
    $foldersToExclude = @('Oracle-Monitoring', 'Classes', 'Mail-Tasks', 'Client')
    [String[]]$excluded = @($foldersToExclude, 'Start-ServerSetup.ps1')
    Get-ChildItem -Exclude $excluded | Where-Object { $_.extension -eq ".ps1" } | ForEach-Object {
		
        Write-Host $_.FullName
        Add-Content $profile ". `"$($_.FullName)`""
    }
}

. $profile

#Restart-ScriptAtStartup
Disable-MapsBroker
Set-StaticIP -StaticIP $config.staticIP
Unblock-Protocol -Protocol "ICMPv4"
Unblock-Protocol -Protocol 25 # SMTP
Unblock-Protocol -Protocol 110 # POP3
Unblock-Protocol -Protocol 143 # IMAP

Unblock-Port -Direction "Inbound" -Port 1521

Install-MozillaFirefox -SleepTime 35
Show-FileExtensions
Install-7Zip
Install-Chocolatey
Install-ChromeBeta
Install-ChromeDriver
Install-SeleniumWebDriver
Install-NETFramework
Get-hMailServer
Get-MozillaThunderbird
Rename-ThisComputer -ComputerName $config.computerName

if (Test-Path "C:\computer_renamed") {
    Install-ADDS
    Install-ADDSForest_Custom -Password $(ConvertTo-SecureString $config.safeModeAdministratorPassword -AsPlainText -Force) -Domain $config.domainName
    Enable-ADRecycleBin -Domain $config.domainName

    [DHCPScope]$dhcpScope = [DHCPScope]::new(
        $config.dhcpScopes[0].name,
        $config.dhcpScopes[0].startRange,
        $config.dhcpScopes[0].endRange,
        $config.dhcpScopes[0].subnetMask,
        $config.dhcpScopes[0].scopeID,
        $config.dhcpScopes[0].dnsServer
    )

    Install-DHCP -Domain $config.domainName -StaticIP $config.staticIP -DHCPscope $dhcpScope
    New-OU -Name $config.ouStudents
    New-ADGroup_Custom -GroupName $config.adGroups[0].groupName -GroupDescription $config.adGroups[0].groupDescription
    New-ADUsers -DefaultPassword $(ConvertTo-SecureString $config.defaultPasswordForStudents -AsPlainText -Force) -GroupToJoin $config.adGroups[0].groupName
    Add-DNSRecords -DomainName $config.domainName -IPv4OfDNS $config.staticIP -NetID "$($config.dhcpScopes[0].scopeID)/24"
    Install-hMailServer

    . $profile

    if (Test-Path "C:\hMailServer_installed") {
        Set-hMailServer -DomainName $config.domainName -SMTPBindToIP $config.staticIP
    }
    Get-OracleEnterpriseDB
    if (Test-Path "C:\oracle_enterprise_downloaded") {
        Install-OracleEnterpriseDB
    }

    # install Thunderbird silently
    if (!(Test-Path "C:\mozillaThunderbird_installed")) {
        C:\Users\Administrator\Downloads\mozillaThunderbird.exe -ms
        New-Item -Path "C:\" -Name "mozillaThunderbird_installed" -ItemType File
    }
    else {
        Write-Host "Thunderbird already installed!" -ForegroundColor Yellow
    }

    if (!(Test-Path "C:\domain_profile_disabled")) {
        Set-NetFirewallProfile -Profile Domain -Enabled False

        New-Item -Path "C:\" -Name "domain_profile_disabled" -ItemType File
    }

    if (Test-Path "C:\oracle_enterprise_installed") {
        Add-NewEnvVariable -VariableName "ORACLE_HOME" -Path "C:\app\19c\product" -Destination "Machine"
        Add-EnvPath -Path "C:\app\19c\product\bin" -Destination "Machine"

        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        Invoke-SQLScript -PathToSql "$env:UserProfile\Desktop\Final-Project\SQL\open_db.sql"
        $swotGroupUsers = Get-ADGroupMember -Identity 'SWOT Developers' -Recursiv | Select-Object -ExpandProperty SamAccountName
        New-Tablespaces -Users $swotGroupUsers -TablespaceSize $config.db.newTablespaceSize
        New-OracleUsers -Users $swotGroupUsers

        if ($true) {
            # run incremental backup at 11:30 pm
            Register-ScheduledTask_Custom -PathToScript "$env:UserProfile\Desktop\Final-Project\Oracle-Monitoring\Start-OracleBackup.ps1" -TaskName 'Oracle Incremental Backup RMAN 1130pm' -At "11:30pm" -Description "It starts incremental backup."
            # report schema at 01:45 am --- "C:\schema_report_$(Get-Date -Format "dd-MM-yyyy-HH-mm-ss").txt"
            Register-ScheduledTask_Custom -PathToScript "$env:UserProfile\Desktop\Final-Project\Oracle-Monitoring\Get-OracleReportSchema.ps1" -TaskName 'Oracle Report Schema RMAN 0145am' -At "1:45am" -Description "It generates report schema."
            # tablespace info how full?
            Register-ScheduledTask_Custom -PathToScript "$env:UserProfile\Desktop\Final-Project\Oracle-Monitoring\Get-TablespacesUsage.ps1" -TaskName 'Oracle Tablespaces Usage 0245am' -At "2:45am" -Description "Generates report about tablespaces usage."


            

            # send email to admin at 5:30 am about:
            #   - report schema
            Register-ScheduledTask_Custom -PathToScript "$env:UserProfile\Desktop\Final-Project\Mail-Tasks\Send-BackupReport.ps1" -TaskName "Send Mail Backup Report 0530am" -At "5:30am" -Description "Sends mail to administrator with backup report."
            #   - tablespace how full?
            Register-ScheduledTask_Custom -PathToScript "$env:UserProfile\Desktop\Final-Project\Mail-Tasks\Send-TablespacesUsage.ps1" -TaskName "Send Mail Tablespaces Usage 0535am" -At "5:35am" -Description "Sends mail to administrator with tablespaces usage."
            # send email to users at 5:30 about:
            #   - their ORA errors
            Register-ScheduledTask_Custom -PathToScript "$env:UserProfile\Desktop\Final-Project\Mail-Tasks\Deploy-ORA_ErrorsExplanations.ps1" -TaskName 'Send ORA errors 0300am' -At "3:00am" -Description "Send ORA errors and explanations how to prevent them."
        }
    }
}