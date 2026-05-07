Set WshShell = CreateObject("WScript.Shell")

Do
    WshShell.Popup "Current Time: " & Time, 1, "VBScript Clock", 64
Loop
