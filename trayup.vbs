Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Kill Explorer process
objShell.Run "taskkill /F /IM explorer.exe", 0, True

' Pause for a moment
WScript.Sleep 2000

' Restart Explorer
objShell.Run "explorer.exe"
