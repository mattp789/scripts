Import-Module ActiveDirectory
#####Function to create a temporary password#####
Function GET-Temppassword() {

Param(

[int]$length=10,

[string[]]$sourcedata

)

 

For ($loop=1; $loop –le $length; $loop++) {

            $TempPassword += ($sourcedata | Get-Random)

            }

return $TempPassword

}
##################################################

#####Defining message variables#####
$ascii=$NULL;For ($a=33;$a –le 126;$a++) {$ascii+=,[char][byte]$a }
$password = GET-Temppassword –length 10 –sourcedata $ascii
$compname = $env:COMPUTERNAME  
$fromaddress = "user@company.com"
$toaddress = user@company.com
$Subject = "Password Change"
$body = " account password has been changed to:" + "  " + "$password"
$smtpserver = "server.com"
##################################################

#####Defining Function Variables#####
$securepassword = ConvertTo-SecureString -String $password -asplaintext -force
##################################################

#####send message#####
$message = new-object System.Net.Mail.MailMessage
$message.From = $fromaddress
$message.To.Add($toaddress)
$message.IsBodyHtml = $True
$message.Subject = $Subject
$message.body = $body
$message.Priority = 2
$smtp = new-object Net.Mail.SmtpClient($smtpserver)
$smtp.Send($message)
##################################################

Set-ADAccountPassword -Reset -NewPassword $securepassword -Identity user
