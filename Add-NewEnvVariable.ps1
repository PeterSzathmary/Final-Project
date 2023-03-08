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
    Add-NewEnvVariable -VariableName "ORACLE_HOME" -Path "C:\app\19c\product\bin" -Destination "Machine"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Add-NewEnvVariable {
    [CmdletBinding()]
    param (
        # new variable name
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $VariableName,

        # path to add to environment
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $Path,

        [Parameter(
            Position = 2,
            Mandatory = $true
        )]
        [ValidateSet("User", "Machine")]
        [string]
        $Destination
    )
        
    begin {
        $exists = $false

        if ([Environment]::GetEnvironmentVariable($VariableName, $Destination)) {
            $exists = $true
        }
    }
    
    process {
        if (!$exists) {
            $NewPath = [Environment]::GetEnvironmentVariable($VariableName, $Destination) + $Path
            [Environment]::SetEnvironmentVariable( $VariableName, $NewPath, $Destination )
        }
        else {
            Write-Host "$VariableName already exists!" -ForegroundColor Yellow
        }
    }
    
    end {
        
    }
}#Add-NewEnvVariable