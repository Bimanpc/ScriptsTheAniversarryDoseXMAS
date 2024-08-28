Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colAdapters = objWMIService.ExecQuery("Select * from Win32_PerfFormattedData_Tcpip_NetworkInterface")

For Each objAdapter in colAdapters
    WScript.Echo "Adapter: " & objAdapter.Name
    WScript.Echo "Bytes Received/sec: " & objAdapter.BytesReceivedPersec
    WScript.Echo "Bytes Sent/sec: " & objAdapter.BytesSentPersec
Next
