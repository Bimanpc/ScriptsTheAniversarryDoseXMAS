' Memory.vbs
' Sample VBScript to discover how much RAM is available on the computer

Option Explicit
Dim objWMIService, perfData, entry
Dim strComputer

strComputer = "."

Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set perfData = objWMIService.ExecQuery("Select * from Win32_PerfFormattedData_PerfOS_Memory")

For Each entry in perfData
    Wscript.Echo "Available memory bytes: " & entry.AvailableBytes
Next

WScript.Quit
