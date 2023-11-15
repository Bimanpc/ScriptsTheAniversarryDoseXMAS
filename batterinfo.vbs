Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

Set colItems = objWMIService.ExecQuery("Select * From Win32_Battery")

For Each objItem in colItems
    WScript.Echo "Battery Status: " & objItem.Status
    WScript.Echo "Battery Level: " & objItem.EstimatedChargeRemaining & "%"
    WScript.Echo "Battery Voltage: " & objItem.DesignVoltage & " mV"
    WScript.Echo "Battery Capacity: " & objItem.DesignCapacity & " mWh"
Next
