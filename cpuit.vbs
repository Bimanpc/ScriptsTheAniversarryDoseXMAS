' GetCPUInfo.vbs
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

Set colItems = objWMIService.ExecQuery("Select * from Win32_Processor")

For Each objItem in colItems
    WScript.Echo "Name: " & objItem.Name
    WScript.Echo "Description: " & objItem.Description
    WScript.Echo "Manufacturer: " & objItem.Manufacturer
    WScript.Echo "Architecture: " & objItem.Architecture
    WScript.Echo "Processor ID: " & objItem.ProcessorID
    WScript.Echo "Number of Cores: " & objItem.NumberOfCores
    WScript.Echo "Number of Logical Processors: " & objItem.NumberOfLogicalProcessors
Next
