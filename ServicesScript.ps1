###########Define Variables########

$compname = $env:COMPUTERNAME
$getservice = (Get-CimInstance win32_service) | Where {$_.state -eq 'stopped' -and $_.startmode -eq 'auto' -and $_.name -ne 'sppsvc' -and $_.name -ne 'clr_optimization_v4.0.30319_64' -and $_.name -ne 'clr_optimization_v4.0.30319_32' -and $_.name -ne 'swprv' -and $_.name -ne 'RemoteRegistry' -and $_.name -ne 'ShellHWDetection'}
$fromaddress = "windows-task@asc.edu"
$toaddress = "windowsadmins@asc.edu"
$Subject = "$compname Service Error"
$body = Get-Content -Path C:\ServiceCheck.txt
$attachment = "C:\ServiceCheck.txt"
$smtpserver = "exchange.asc.edu"

####################################
$getservice | Sort displayname | select displayname, name, state, startmode | ft -auto |out-file C:\ServiceCheck.txt;

if((Get-Content -Path "c:\ServiceCheck.txt") -ne $Null){
Add-Content C:\ServiceCheck.txt "These Services have stopped:","","Attempting to restart Services","","Rechecking for stopped services","","If no other information, services restarted succesfully";
};

$getservice | Invoke-CimMethod -MethodName StartService;

Start-Sleep -s 15;

(Get-CimInstance win32_service) | Where {$_.state -eq 'stopped' -and $_.startmode -eq 'auto' -and $_.name -ne 'sppsvc' -and $_.name -ne 'clr_optimization_v4.0.30319_64' -and $_.name -ne 'clr_optimization_v4.0.30319_32' -and $_.name -ne 'swprv' -and $_.name -ne 'RemoteRegistry' -and $_.name -ne 'ShellHWDetection'} | Sort displayname | select displayname, name, state, startmode | ft -auto |out-file -append C:\ServiceCheck.txt;

if((Get-Content -Path "c:\ServiceCheck.txt") -eq $Null){
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
$message.Priority = 2
$smtp = new-object Net.Mail.SmtpClient($smtpserver)
$smtp.Send($message)
}
