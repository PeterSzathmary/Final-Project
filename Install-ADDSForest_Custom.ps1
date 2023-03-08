<#
.SYNOPSIS
    Install AD DS Forest
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-ADDSForest_Custom -Password $(ConvertTo-SecureString <=some_password=> -AsPlainText -Force) -Domain <=some_domain_name=>
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-ADDSForest_Custom {
    [CmdletBinding()]
    param (
        # safe mode administrator password
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [securestring]
        $Password,

        # domain name
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $Domain
    )
    
    begin {
        $Flag = "forest_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "AD DS Forest already installed" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            #$secureString = ConvertTo-SecureString $Password -AsPlainText -Force
            #$domain = $domainName
            Install-ADDSforest -DomainName $Domain -InstallDns -SafeModeAdministratorPassword $Password -Confirm:$false

            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "AD DS Forest successfully installed" -ForegroundColor Green
        }
    }
}#Install-ADDSForest_Custom