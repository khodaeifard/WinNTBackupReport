                            #..... Backup Report Script v 2.0.....#
                            #..............extendIT GmbH..........#
                            #........By: Mehdi Khodaeifard........#

# Set up variables
$SmtpServer = "mail.example.com"
$SmtpPort = 25
$FromEmail = "no-reply@example.com"
$ToEmail = "debug@yourdomain.com"
$OutputFile = "C:\BackupScript\BackupResults.txt"

# Create backup results file
$LastBackup = (Get-Date $NextBackup) - (New-TimeSpan -day 1)
Get-WinEvent -LogName "Microsoft-Windows-Backup" | Where {$_.timecreated -ge $LastBackup} | Sort-Object TimeCreated | Format-Table TimeCreated, Message -AutoSize -Wrap | Out-File $OutputFile

# Construct and send email
$SmtpClient = new-object system.net.mail.smtpClient
$Msg = new-object Net.Mail.MailMessage
$SmtpClient.host = $SmtpServer
$SmtpClient.Port = $SmtpPort
$computer = gc env:computername
$Msg.From = $FromEmail
$Msg.To.Add($ToEmail)
$Msg.Subject = "## Backup result on " +$Computer +" ##"
$Msg.Body = "The backup for " +$Computer+" has completed. Please see the attached file for backup results."
$Msg.Attachments.Add($OutputFile)
$SmtpClient.Send($Msg)