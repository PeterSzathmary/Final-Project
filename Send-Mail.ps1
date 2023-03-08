

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
    Send-Mail -To "Ainslee Ash <aash@windows.lab>" -From "Administrator <administrator@windows.lab>" -Subject "hello with HTML" -Attachments "C:\backup_log_13-02-2023-19-15-38.txt"

    -- OR --

    send mail with multiple attachments

    Send-Mail -To "Ainslee Ash <aash@windows.lab>" -From "Administrator <administrator@windows.lab>" -Subject "hello with HTML" -Attachments "C:\backup_log_13-02-2023-19-15-38.txt", "C:\schema_report_13-02-2023-18-23-05.txt"

    -- OR --

    send email with no attachments

    Send-Mail -To "Administrator <administrator@windows.lab>" -From "Administrator <administrator@windows.lab>" -Subject "hello with HTML" -HtmlFilePath "$env:UserProfile\Desktop\Final-Project\HTML\test.html" -CssFilePath "$env:UserProfile\Desktop\Final-Project\CSS\test.css"

    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Send-Mail {
    [CmdletBinding()]
    param (
        # to whom send the mail
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $To,

        # from who
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $From,

        # email subject
        [Parameter(
            Position = 2,
            Mandatory = $true
        )]
        [string]
        $Subject,

        # attachment
        [Parameter(
            #Position = 3,
            Mandatory = $false
        )]
        [string[]]
        $Attachments,

        # html file path
        [Parameter(
            #Positition=4,
            Mandatory = $false
        )]
        [string]
        $HtmlFilePath,

        # css file path
        [Parameter(
            #Positition=5,
            Mandatory = $false
        )]
        [string]
        $CssFilePath
    )
    
    begin {

        $body = ""

        if ($HtmlFilePath -ne "" -and (Test-Path $HtmlFilePath)) {
            $html = Get-Content $HtmlFilePath | Out-String
            $html = $html.Replace("**VarUsername**", $($env:USERNAME))

            if ($CssFilePath -ne "" -and (Test-Path $CssFilePath)) {
                $css = Get-Content $CssFilePath | Out-String
                $html = $html.Replace("/*VarStyle*/", $css)
            }

            $body = ConvertTo-Html -PreContent @"
        $html
"@
        }

        $mailParams = @{
            SmtpServer = "localhost"
            to         = $To
            from       = $From
            Subject    = $Subject
            Body       = $($body | Out-String)
            BodyAsHtml = $true
            Encoding   = "UTF8"
        }

        if ($Attachments) {
            $mailParams.Attachments = $Attachments
        }
        
    }
    
    process {
        Send-MailMessage @mailParams
    }
    
    end {
        
    }
}#Send-Mail