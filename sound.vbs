Option Explicit

Dim objShell, intVolume

Set objShell = CreateObject("WScript.Shell")

' Get the current sound volume level
intVolume = objShell.RegRead("HKEY_CURRENT_USER\Software\Microsoft\Multimedia\Audio\OutputVolume")

WScript.Echo "Current Sound Volume Level: " & intVolume

' Set the sound volume level (range: 0 to 65535)
objShell.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Multimedia\Audio\OutputVolume", 5000, "REG_DWORD"

WScript.Echo "Sound Volume Level set to: 5000"

Set objShell = Nothing
