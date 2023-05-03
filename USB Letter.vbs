Dim oFSO, oDrive
Const USBDRIVE=1
Set oFSO = WScript.CreateObject("Scripting.FileSystemObject")
For Each oDrive In oFSO.Drives
If oDrive.DriveType = USBDRIVE And oDrive.DriveLetter <> "A" Then
WScript.Echo oDrive.DriveLetter
End If
Next