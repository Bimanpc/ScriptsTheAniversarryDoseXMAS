' CPUInfo.vbs

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcessors = objWMIService.ExecQuery("Select * from Win32_Processor")

Wscript.Echo "CPU Information:"

For Each objProcessor in colProcessors
    Wscript.Echo "-----------------------------------"
    Wscript.Echo "Name: " & objProcessor.Name
    Wscript.Echo "Description: " & objProcessor.Description
    Wscript.Echo "Manufacturer: " & objProcessor.Manufacturer
    Wscript.Echo "Number of Cores: " & objProcessor.NumberOfCores
    Wscript.Echo "Number of Logical Processors: " & objProcessor.NumberOfLogicalProcessors
    Wscript.Echo "Architecture: " & objProcessor.Architecture
Next

Set objWMIService = Nothing
Set colProcessors = Nothing
