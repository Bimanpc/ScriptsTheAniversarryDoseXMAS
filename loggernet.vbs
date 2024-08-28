Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile("C:\NetworkLog.txt", 8, True)

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colAdapters = objWMIService.ExecQuery("Select * from Win32_PerfFormattedData_Tcpip_NetworkInterface")

For Each objAdapter in colAdapters
    strData = Now & " - Adapter: " & objAdapter.Name & " - Bytes Received/sec: " & objAdapter.BytesReceivedPersec & " - Bytes Sent/sec: " & objAdapter.BytesSentPersec
    objFile.WriteLine strData
Next

objFile.Close
