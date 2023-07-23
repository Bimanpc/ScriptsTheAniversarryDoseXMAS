Option Explicit

Dim objShell, objWMI
Dim strCmd, strOutput

Set objShell = CreateObject("WScript.Shell")
Set objWMI = GetObject("winmgmts:\\.\root\cimv2")

' Command to get SMART attributes using smartctl
strCmd = "smartctl.exe -a /dev/sda" ' Replace "/dev/sda" with your disk identifier (use /dev/sdX on Linux)

' Execute the command and capture the output
strOutput = objShell.Exec(strCmd).StdOut.ReadAll()

' Display the output (you can do further parsing here)
MsgBox strOutput

Set objShell = Nothing
Set objWMI = Nothing
