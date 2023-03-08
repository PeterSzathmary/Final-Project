<#
.SYNOPSIS
    Invoke RMAN script at given path.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Invoke-RMANScript -PathToRman "C:\test.rman" -FullLogPath "C:\test_log.txt"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Invoke-RMANScript {
    [CmdletBinding()]
    param (
        # path to the rman script
        [Parameter(
            Position=0,
            Mandatory=$true
        )]
        [string]
        $PathToRman,

        # full path of log destination file
        [Parameter(
            Position=1,
            Mandatory=$true
        )]
        [string]
        $FullLogPath
    )
    
    begin {
        
    }
    
    process {
        rman.exe cmdfile=$PathToRman using "'$FullLogPath'"
    }
    
    end {
        
    }
}#Invoke-RMANScript