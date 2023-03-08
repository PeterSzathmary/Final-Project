<#
.SYNOPSIS
    Creates new AD users
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    New-ADUsers -DefaultPassword $(ConvertTo-SecureString <=some_password=> -AsPlainText -Force) -GroupToJoin "swot_group"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function New-ADUsers {
    [CmdletBinding()]
    param (

        # default password for new users
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [securestring]
        $DefaultPassword,

        # group to join swot students
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $GroupToJoin
    )
    
    begin {
        $Flag = "students_created"
        if (Test-Path "C:\$Flag") {
            Write-Host "AD Users alredy created" -ForegroundColor Yellow
            $Skip = $true
        }
    }
    
    process {
        if ($Skip -ne $true) {
            $mockCSVFilePath = Read-Host "File path to Mock CSV data"
            Write-Host "Creating students..."
            $students = Import-Csv -Path $mockCSVFilePath

            foreach ($student in $students) {
    
                $samAccountName = "$($student.first_name.Substring(0, 1))$($student.last_name)".ToLower()
            
                New-ADUser `
                    -Name "$($student.first_name) $($student.last_name)" `
                    -GivenName "$($student.first_name)" `
                    -Surname "$($student.last_name)" `
                    -UserPrincipalName "$($student.first_name).$($student.last_name)@$domainName" `
                    -SamAccountName $samAccountName `
                    -AccountPassword $DefaultPassword `
                    -Path "OU=STUDENTS,DC=WINDOWS,DC=LAB"
    
                Set-ADUser -Identity $samAccountName -ChangePasswordAtLogon $true
                Enable-ADAccount -Identity $samAccountName

                if ($student.team -eq "swot") {
                    Add-ADGroupMember -Identity $GroupToJoin -Members $samAccountName
                }
            }
    
            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
    }
    
    end {
        if ($Skip -ne $true) {
            Write-Host "AD Users successfully created" -ForegroundColor Yellow
        }
    }
}#New-ADUsers