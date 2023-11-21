Option Explicit

Dim currentDate, currentTime, message

' Get the current date and time
currentDate = Date
currentTime = Time

' Create the message
message = "Current Date: " & currentDate & vbCrLf & "Current Time: " & currentTime

' Display the message in a message box
MsgBox message, vbInformation, "Orthodox Christian Calendar"

' End of the script
WScript.Quit
