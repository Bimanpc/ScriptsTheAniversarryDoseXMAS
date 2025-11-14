' WLAN Optimize Script (VBScript)
' Flush DNS, reset IP, restart WLAN adapter

Set objShell = CreateObject("WScript.Shell")

' Flush DNS cache
objShell.Run "ipconfig /flushdns", 0, True

' Release IP
objShell.Run "ipconfig /release", 0, True

' Renew IP
objShell.Run "ipconfig /renew", 0, True

' Reset Winsock
objShell.Run "netsh winsock reset", 0, True

' Restart WLAN adapter (replace with your adapter name!)
adapterName = """Wi-Fi"""
objShell.Run "netsh interface set interface " & adapterName & " admin=disable", 0, True
WScript.Sleep 3000
objShell.Run "netsh interface set interface " & adapterName & " admin=enable", 0, True

MsgBox "WLAN optimization complete. Try your connection again."
