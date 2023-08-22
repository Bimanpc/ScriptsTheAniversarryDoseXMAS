Option Explicit

Dim objWMIService, colProcessors, objProcessor

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcessors = objWMIService.ExecQuery("Select * from Win32_Processor")

For Each objProcessor in colProcessors
    WScript.Echo "Processor Information:"
    WScript.Echo "  Name: " & objProcessor.Name
    WScript.Echo "  Manufacturer: " & objProcessor.Manufacturer
    WScript.Echo "  Max Clock Speed: " & objProcessor.MaxClockSpeed & " MHz"
    WScript.Echo "  Number of Cores: " & objProcessor.NumberOfCores
    WScript.Echo "  Number of Logical Processors: " & objProcessor.NumberOfLogicalProcessors
Next

Set objWMIService = Nothing
