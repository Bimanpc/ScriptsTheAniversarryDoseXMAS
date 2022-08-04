Option Explicit
Dim objNetwork, strDriveLetter, strRemotePath, strUser, strPassword, strProfile, WshShell

' Set passphrase & network share to variables.
strDriveLetter = "Z:"
strRemotePath = "\\server\share"
strUser = "domain\username"
strPassword = "topsecret"
strProfile = "false"

' Create a network object (objNetwork) do apply MapNetworkDrive Z:
Set objNetwork = WScript.CreateObject("WScript.Network")
objNetwork.MapNetworkDrive strDriveLetter, strRemotePath, _
strProfile, strUser, strPassword

' Open message box,  remove the apostrophe at the beginning.
' WScript.Echo "Map Network Drive " & strDriveLetter
MsgBox " Explorer Launch Network Drives " & strDriveLetter, vbInformation, "Network Drive Mapping"
' Explorer will open the mapped network drive.
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Run "explorer.exe /e," & strDriveLetter, 1, false
WScript.Quit