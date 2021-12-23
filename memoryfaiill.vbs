strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
set objRefresher = CreateObject("WbemScripting.SWbemRefresher")
Set objMemory = objRefresher.AddEnum _
(objWMIService, "Win32_PerfFormattedData_PerfOS_Memory").objectSet
objRefresher.Refresh
For Each intAvailableBytes in objMemory
If intAvailableBytes.AvailableMBytes < 4 Then
Wscript.Echo "Available memory has below 4 megabytes."
End If
Next
objRefresher.Refresh