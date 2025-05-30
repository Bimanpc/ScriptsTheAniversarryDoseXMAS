' This is a simple VBScript to launch a 3D modeling software
' Replace "Your3DSoftwarePath" with the actual path to your 3D modeling software

Option Explicit

Dim softwarePath
softwarePath = "C:\Path\To\Your\3DModelingSoftware.exe" ' Change this path

Dim shell
Set shell = CreateObject("WScript.Shell")

' Launch the 3D modeling software
shell.Run """" & softwarePath & """", 1, False

Set shell = Nothing

MsgBox "3D Modeling Software Launched!"
