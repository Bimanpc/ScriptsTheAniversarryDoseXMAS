' Map network drives
Set objNetwork = CreateObject("WScript.Network")
objNetwork.MapNetworkDrive "Z:", "\\server\share"
objNetwork.MapNetworkDrive "Y:", "\\server\another_share"
' Add more drive mappings as needed
