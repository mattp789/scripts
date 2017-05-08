Import-Module ActiveDirectory
$first = Read-host -Prompt "Enter the New User's First Name"
$last = Read-host -Prompt "Enter the New User's Last Name"
$Name = $first + " " + $last
$Passwordinput = Read-host -Prompt "Enter a password for the user" -AsSecureString
$Password = (ConvertTo-SecureString $Passwordinput -asPlainText -force)
$samaccount = $first.Substring(0,1) + $last
$templateuser = Read-host -Prompt "What's the user account you'd like to use as a template?"
$usertemplate = Get-ADUser -Identity $templateuser
$path = (Get-ADUser $templateuser).distinguishedname.Split(',',2)[1]
$email = $samaccount + "@company.com"
$phone = Read-host -Prompt "Enter the user's phone number with format(XXX.XXX.XXXX)"
$location = Read-host -Prompt "I this an hsv or mtg user?"

if ($location -eq "mtg") {
Write-Host "Creating user $samaccount"
New-ADUser -SamAccountName $samaccount -Name $Name -GivenName $first -Surname $last -AccountPassword $Password -OfficePhone $phone -Enabled 1 -DisplayName $Name -HomeDirectory "\\server\share\$samaccount" -HomeDrive "J:" -PasswordNeverExpires 1 -UserPrincipalName $email -path $path;
Write-Host "Setting permissions equal to $templateuser"
Get-ADuser -identity $templateuser -Properties memberof| Select-object -ExpandProperty memberof | Add-AdgroupMember -Members $samaccount;
Write-Host "Setting the user to be protected from accidental deletion"
Get-ADObject -filter {(ObjectClass -eq "user")} | where {$_.name -eq $name} | Set-ADObject -ProtectedFromAccidentalDeletion:$true;
Set-ExecutionPolicy RemoteSigned;
$UserCredential = Get-Credential;
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://server.com/PowerShell/ -Authentication Kerberos -Credential $UserCredential;
Write-Host "Connecting to server.com"
Import-PSSession $Session;
Write-Host "Creating user mailbox"
enable-mailbox -identity $samaccount -Database "Mailbox Database"
Write-Host "Disconnecting from server.com"
Remove-PSSession $session;
}
elseif ($location -eq "hsv") {
Write-Host "Creating user $samaccount"
New-ADUser -SamAccountName $samaccount -Name $Name -GivenName $first -Surname $last -AccountPassword $Password -OfficePhone $phone -Enabled 1 -DisplayName $Name -HomeDirectory "\\server\share\$samaccount" -HomeDrive "J:" -PasswordNeverExpires 1 -UserPrincipalName $email -path $path;
Write-Host "Setting permissions equal to $templateuser"
Get-ADuser -identity $templateuser -Properties memberof| Select-object -ExpandProperty memberof | Add-AdgroupMember -Members $samaccount;
Write-Host "Setting the user to be protected from accidental deletion"
Get-ADObject -filter {(ObjectClass -eq "user")} | where {$_.name -eq $name} | Set-ADObject -ProtectedFromAccidentalDeletion:$true;
Set-ExecutionPolicy RemoteSigned;
$UserCredential = Get-Credential;
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://server.com/PowerShell/ -Authentication Kerberos -Credential $UserCredential;
Write-Host "Connecting to server.com"
Import-PSSession $Session;
enable-mailbox -identity $samaccount -Database "Mailbox Database"
Write-Host "Disconnecting from server.com"
Remove-PSSession $session;
}
else {
Write-Host -foreground Red "Please choose a valid location"
exit
}