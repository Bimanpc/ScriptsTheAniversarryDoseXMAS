' Create a Windows Shell object
Set objShell = CreateObject("WScript.Shell")

' Clear the clipboard
objShell.Run "cmd /c echo off | clip", 0, True

' Display a message indicating that the clipboard has been cleared
MsgBox "Clipboard has been clear.", vbInformation, "Clipboard Cleared"
