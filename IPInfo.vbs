Option Explicit

Dim objWMIService, colItems, objItem

' Create a WMI service object
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' Query for network adapters
Set colItems = objWMIService.ExecQuery("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True")

' Iterate through the results
For Each objItem In colItems
    ' Display IP Address
    WScript.Echo "IP Address: " & objItem.IPAddress(0)
Next
