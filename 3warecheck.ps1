###########Define Variables########

tw_cli /c0 show all | out-file C:\3ware.txt
tw_cli /c0 show alarms | out-file C:\3ware.txt -append
$fromaddress = "windows-task@company.com"
$toaddress = "sysadmins@company.com
$Subject = "3ware notification"
$body = "3ware notification from Hyper-V server"
$attachment = "C:\3ware.txt"
$smtpserver = "mail.company.com"

####################################

if((Get-Content C:\3ware.txt) -like '*SPARE     OK*'){
exit
}

else
{
$message = new-object System.Net.Mail.MailMessage
$message.From = $fromaddress
$message.To.Add($toaddress)
$message.IsBodyHtml = $True
$message.Subject = $Subject
$attach = new-object Net.Mail.Attachment($attachment)
$message.Attachments.Add($attach)
$message.body = $body
$smtp = new-object Net.Mail.SmtpClient($smtpserver)
$smtp.Send($message)}
