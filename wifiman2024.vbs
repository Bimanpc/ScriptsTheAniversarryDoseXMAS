Set objShell = CreateObject("Wscript.Shell")
strCommand = "cmd /c netsh wlan show network mode=bssid>%Appdata%\BSSID.txt"
objShell.Run strCommand, 0, True

ResultFile = objShell.ExpandEnvironmentStrings("%Appdata%\BSSID.txt")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(ResultFile, 1) ' ForReading

strText = objFile.ReadAll
arrLines = Split(strText, vbCrlf)

For i = 4 to UBound(arrLines) - 1
    WScript.Echo arrLines(i)
Next
