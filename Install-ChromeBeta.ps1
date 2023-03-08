<#
.SYNOPSIS
    Install Chrome Beta
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-ChromeBeta
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-ChromeBeta {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $Flag = "chrome_beta_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "Chrome Beta already installed." -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $chromePath = "C:\Program Files\Google\Chrome\Application"

            New-Item -ItemType Directory -Force -Path $chromePath

            $url = "https://dl.google.com/tag/s/appguid%3D%7B8237E44A-0054-442C-B6B6-EA0509993955%7D%26iid%3D%7B2ECB1D76-9481-D047-CBDC-9AE27B179AB2%7D%26lang%3Den%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%2520Beta%26needsadmin%3Dprefers%26ap%3D-arch_x64-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"
            $out = "C:\Users\Administrator\Downloads\chrome_beta.exe"

            Invoke-WebRequest -Uri $url -OutFile $out

            C:\Users\Administrator\Downloads\chrome_beta.exe | Out-Null
            Copy-Item -Path "C:\Program Files\Google\Chrome Beta\Application\*" -Destination $chromePath -Recurse
            #https://dl.google.com/tag/s/appguid%3D%7B8237E44A-0054-442C-B6B6-EA0509993955%7D%26iid%3D%7B2ECB1D76-9481-D047-CBDC-9AE27B179AB2%7D%26lang%3Den%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%2520Beta%26needsadmin%3Dprefers%26ap%3D-arch_x64-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe
            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "Chrome Beta successfully installed." -ForegroundColor Green
        }
    }
}#Install-ChromeBeta