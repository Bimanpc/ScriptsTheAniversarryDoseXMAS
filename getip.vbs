strComputer = "www.google.com"

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PingStatus WHERE Address = '" & strComputer & "'")

For Each objItem in colItems
    If objItem.StatusCode = 0 Then
        WScript.Echo "IP Address: " & objItem.ProtocolAddress
    Else
        WScript.Echo "Ping request failed."
    End If
Next
