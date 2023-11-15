Set objShell = CreateObject("WScript.Shell")

' Specify the drive letter you want to change to
DriveLetter = "D:"

' Change the current directory to the specified drive
objShell.CurrentDirectory = DriveLetter
