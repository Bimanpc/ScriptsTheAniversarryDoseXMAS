On Error Resume Next
' Create a FileSystemObject
Set FSO = CreateObject("Scripting.FileSystemObject")
' Provide file path
Dim result, strComputer, outFile, PropertyArr, ArrayItem
outFile = "C:\OK2.txt"
' Sets computer name to the current computer name
strComputer = "."
' Setting up file to write
Set objFile = FSO.CreateTextFile(outFile, True)
' Connect to the WMI Service
Set CIMV2 = GetObject("winmgmts:" & "\\" & strComputer & "\root\CIMV2")
If Err Then
    WScript.StdOut.WriteLine "Unable to access WMI Service."
    WScript.Quit 32
End If
' Fetch all details from Win32_computersystem
Set Win32_DiskDrive = CIMV2.ExecQuery("Select * from Win32_DiskDrive")
PropertyArr = Array("Model","MediaType")
For Each item_PropertyArr In PropertyArr
    ArrayItem = item_PropertyArr
Next
For Each item In Win32_DiskDrive
    result = item.ArrayItem
    WScript.Echo "Result: " & result
Next