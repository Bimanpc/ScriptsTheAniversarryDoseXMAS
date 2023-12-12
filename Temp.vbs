' SSD Temperature Checker Script

On Error Resume Next

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' Specify the drive you want to check (e.g., "C:")
DriveLetter = "C:"

' Query information about the physical disk drives
Set colItems = objWMIService.ExecQuery("Select * from Win32_DiskDrive")

For Each objItem In colItems
    ' Check if the drive matches the specified drive letter
    If InStr(objItem.DeviceID, DriveLetter) > 0 Then
        ' Retrieve the temperature information
        Set colSensors = objWMIService.ExecQuery("Select * from MSStorageDriver_ATAPISmartData")

        For Each objSensor In colSensors
            If objSensor.InstanceName = objItem.DeviceID Then
                ' Retrieve the temperature attribute (ID 194)
                For Each attr In objSensor.VendorSpecific
                    If attr.AttributeID = 194 Then
                        ' Display the temperature
                        WScript.Echo "SSD Temperature for Drive " & DriveLetter & ": " & attr.RawValue - 273 & "°C"
                    End If
                Next
            End If
        Next
    End If
Next

If Err.Number <> 0 Then
    ' Handle errors
    WScript.Echo "Error: " & Err.Description
End If

On Error GoTo 0
