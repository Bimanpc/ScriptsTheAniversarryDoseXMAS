$creds = Get-Credential $UserName
$getUsername = $creds.GetNetworkCredential( ).UserName
$getPassword = $creds.GetNetworkCredential( ).Pass