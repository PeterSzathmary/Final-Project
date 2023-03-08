# install Thunderbird
# keep firewall on
# add to domain

# Self-elevate the script if required
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        exit
    }
}

# Add-Content $profile ". `"C:\Users\Administrator\Desktop\Final-Project\Add-EnvPath.ps1`""

# . $profile

# Allow ICMPv4 (ping)
if (!(Test-Path "C:\allow_icmpv4")) {
    New-NetFirewallRule -DisplayName "Allow ICMPv4 In Requests" -Direction Inbound -Program Any -Protocol ICMPv4 -Action Allow
    New-NetFirewallRule -DisplayName "Allow ICMPv4 Out Requests" -Direction Outbound -Program Any -Protocol ICMPv4 -Action Allow

    New-Item -Path "C:\" -Name "allow_icmpv4" -ItemType File
}
else {
    Write-Host "ICMPv4 In and Out requests already configured." -ForegroundColor Yellow
}

if (!(Test-Path "C:\file_extensions")) {
    <# Action to perform if the condition is true #>

    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    Set-ItemProperty . HideFileExt "0"
    Pop-Location
    Stop-Process -processName: Explorer -force # This will restart the Explorer service to make this work.

    New-Item -Path "C:\" -Name "file_extensions" -ItemType File
}
else {
    Write-Host "File extansions already enabled" -ForegroundColor Yellow
}

if (!(Test-Path "C:\thunderbird_downloaded")) {
    $url = "https://download.mozilla.org/?product=thunderbird-102.6.1-SSL&os=win64&lang=en-US"
    $output = "C:\mozillaThunderbird.exe"
    $start_time = Get-Date

    Invoke-WebRequest -Uri $url -OutFile $output

    Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

    New-Item -Path "C:\" -Name "thunderbird_downloaded" -ItemType File
}
else {
    Write-Host "Thunderbird already installed" -ForegroundColor Yellow
}

if ((Test-Path "C:\thunderbird_downloaded") -and !(Test-Path "C:\thunderbird_installed")) {
    C:\mozillaThunderbird.exe -ms

    Start-Sleep 30

    Remove-Item C:\mozillaThunderbird.exe

    New-Item -Path "C:\" -Name "thunderbird_installed" -ItemType File
}

if (!(Test-Path "C:\oracle_instantclient_downloaded")) {
    Invoke-WebRequest "https://download.oracle.com/otn_software/nt/instantclient/1918000/instantclient-basic-windows.x64-19.18.0.0.0dbru.zip" -OutFile "$env:UserProfile\Downloads\instantclient-basic-package.zip"
    Invoke-WebRequest "https://download.oracle.com/otn_software/nt/instantclient/1918000/instantclient-sqlplus-windows.x64-19.18.0.0.0dbru.zip" -OutFile "$env:UserProfile\Downloads\instantclient-sqlplus-package.zip"
    Invoke-WebRequest "https://download.oracle.com/otn_software/nt/instantclient/1918000/instantclient-tools-windows.x64-19.18.0.0.0dbru.zip" -OutFile "$env:UserProfile\Downloads\instantclient-tools-package.zip"

    New-Item -Path "C:\" -Name "oracle_instantclient_downloaded" -ItemType File
}
else {
    Write-Host "Oracle Instant Client already downloaded" -ForegroundColor Yellow
}

if (!(Test-Path "C:\oracle_instantclient_archive_expanded")) {
    Expand-Archive "$env:UserProfile\Downloads\instantclient-basic-package.zip" -DestinationPath "C:\Program Files (x86)\oracle-instantclient"
    Expand-Archive "$env:UserProfile\Downloads\instantclient-sqlplus-package.zip" -DestinationPath "C:\Program Files (x86)\oracle-instantclient"
    Expand-Archive "$env:UserProfile\Downloads\instantclient-tools-package.zip" -DestinationPath "C:\Program Files (x86)\oracle-instantclient"

    New-Item -Path "C:\" -Name "oracle_instantclient_archive_expanded" -ItemType File
}
else {
    Write-Host "Oracle Instant Client already expanded" -ForegroundColor Yellow
}

if ((Test-Path "C:\oracle_instantclient_archive_expanded") -and !(Test-Path "C:\oracle_instantclient_path_added")) {
    $NewPath = [Environment]::GetEnvironmentVariable("Path", "Machine") + [IO.Path]::PathSeparator + "C:\Program Files (x86)\oracle-instantclient\instantclient_19_18"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")

    $Path = "C:\Program Files (x86)\oracle-instantclient\instantclient_19_18\glogin.sql"
    Clear-Content $Path
    Add-Content $Path "`nSET ERRORLOGGING ON;"
    Add-Content $Path "set sqlprompt `"&_user> `""

    New-Item -Path "C:\" -Name "oracle_instantclient_path_added" -ItemType File
}
else {
    Write-Host "Oracle Instant Client path already added" -ForegroundColor Yellow
}

# Rename computer
if (!(Test-Path "C:\computer_renamed")) {
    $newName = Read-Host "New name for computer"
    Write-Host "The computer name will be renamed to: $newName"
    Write-Host "For this change to apply, you need to restart computer."
    $answer = Read-Host "Restart now? [Y/y] Yes [N/n] No"
    if ($answer.ToLower() -eq "y") {

        New-Item -Path "C:\" -Name "computer_renamed" -ItemType File

        Rename-Computer -NewName $newName -Restart

    }
    elseif ($answer.ToLower() -eq "n") {
        Write-Host "Dont't forget to restart computer later." -ForegroundColor Yellow
        Write-Host -NoNewline "`nPress any key to continue..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
    else {
        Write-Host "Bad input!! Cancelling restart..." -ForegroundColor Red
        Write-Host -NoNewline "`nPress any key to continue..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
}
else {
    Write-Host "Computer already renamed." -ForegroundColor Yellow
}

# Add to domain
if (!(Test-Path "C:\added_to_domain")) {
    $domainName = Read-Host "Enter a domain name you want to join"

    New-Item -Path "C:\" -Name "added_to_domain" -ItemType File

    Add-Computer -DomainName $domainName -Restart
}
else {
    Write-Host "Already in domain." -ForegroundColor Yellow
}

# .\network\admin\tnsnames.ora:
# ORCL =
# (DESCRIPTION =
# (ADDRESS = (PROTOCOL = TCP)(HOST = WIN-DC-001.windows.lab)(PORT = 1521))
# (CONNECT_DATA =
#   (SERVER = DEDICATED)
#   (SERVICE_NAME = orcl.windows.lab)
# )
# )
# .\network\admin\sqlnet.ora:
# 
# download:
#       basic package, sqlplus package, tools package
#       https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html
#       extract packages and copy all to basic package

# when in basic directory and everything copied
# .\sqlplus.exe pjako/pjako123@WIN-DC-001.windows.lab:1521/orclpdb.windows.lab