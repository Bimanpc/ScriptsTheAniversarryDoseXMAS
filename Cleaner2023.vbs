Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")

For Each objItem in colItems
    Wscript.Echo "Total Physical Memory (MB): " & objItem.TotalVisibleMemorySize
    Wscript.Echo "Free Physical Memory (MB): " & objItem.FreePhysicalMemory
Next
