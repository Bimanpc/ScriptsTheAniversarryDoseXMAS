Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

Set colItems = objWMIService.ExecQuery("Select * from Win32_PhysicalMemory")

For Each objItem in colItems
    WScript.Echo "Capacity: " & objItem.Capacity & " bytes"
    WScript.Echo "Speed: " & objItem.Speed & " MHz"
    WScript.Echo "Type: " & objItem.MemoryType
Next

Set colItems = objWMIService.ExecQuery("Select * from Win32_ComputerSystem")

For Each objItem in colItems
    WScript.Echo "Total Physical Memory: " & objItem.TotalPhysicalMemory & " bytes"
Next
