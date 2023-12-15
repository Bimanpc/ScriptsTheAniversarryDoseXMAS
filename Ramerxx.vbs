' VBScript to check RAM (Memory) information

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' Query for total physical memory
Set colItems = objWMIService.ExecQuery("Select * from Win32_ComputerSystem")
For Each objItem In colItems
    totalPhysicalMemory = objItem.TotalPhysicalMemory
Next

' Convert bytes to gigabytes for easier readability
totalPhysicalMemoryGB = FormatNumber(totalPhysicalMemory / (1024 ^ 3), 2)

' Display the total physical memory
WScript.Echo "Total Physical Memory: " & totalPhysicalMemoryGB & " GB"
