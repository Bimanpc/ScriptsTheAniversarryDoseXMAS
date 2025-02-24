Option Explicit
Dim objWMIService, colDrives, objDrive, fso, logFile
Dim prevDrives, newDrives, diffDrives
Dim logFilePath

' Define log file path
logFilePath = "C:\USBLog.txt"

' Create FileSystemObject
Set fso = CreateObject("Scripting.FileSystemObject")

' Initialize previous drive list
prevDrives = GetDriveList()

' Loop to monitor USB changes
Do
    WScript.Sleep 2000 ' Check every 2 seconds
    newDrives = GetDriveList()
    
    ' Compare previous and current drive lists
    diffDrives = CompareDrives(prevDrives, newDrives)
    
    If diffDrives <> "" Then
        LogUSBEvent diffDrives
    End If
    
    prevDrives = newDrives
Loop

' Function to get all removable drive letters
Function GetDriveList()
    Dim driveList, objDrive
    driveList = ""
    
    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set colDrives = objWMIService.ExecQuery("Select * from Win32_LogicalDisk Where DriveType = 2") ' Only removable drives
    
    For Each objDrive In colDrives
        driveList = driveList & objDrive.DeviceID & ","
    Next
    
    GetDriveList = driveList
End Function

' Function to compare old and new drive lists
Function CompareDrives(oldList, newList)
    Dim added, removed, drive, result
    added = ""
    removed = ""
    result = ""
    
    ' Detect added drives
    For Each drive In Split(newList, ",")
        If drive <> "" And InStr(oldList, drive) = 0 Then
            added = added & drive & " (Inserted), "
        End If
    Next
    
    ' Detect removed drives
    For Each drive In Split(oldList, ",")
        If drive <> "" And InStr(newList, drive) = 0 Then
            removed = removed & drive & " (Removed), "
        End If
    Next
    
    result = added & removed
    CompareDrives = result
End Function

' Function to log USB events
Sub LogUSBEvent(eventDetails)
    Dim logEntry, logFile
    logEntry = Now & " - " & eventDetails & vbCrLf
    
    ' Append to log file
    Set logFile = fso.OpenTextFile(logFilePath, 8, True)
    logFile.WriteLine logEntry
    logFile.Close
End Sub
