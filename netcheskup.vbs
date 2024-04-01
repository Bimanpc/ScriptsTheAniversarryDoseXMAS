Function IsConnectionON()
    Set oFSO = CreateObject("Scripting.FileSystemObject")
    Dim isInternetConnected
    isInternetConnected = 0
    Set oShell = WScript.CreateObject("WScript.Shell")
    strHost = "bing.com"
    strPingCommand = "ping -n 1 -w 300 " & strHost
    ' Execute the ping command
    ' (you can adjust the timeout and host as needed)
    ' If successful, the internet connection is ON
    If oShell.Run(strPingCommand, 0, True) = 0 Then
        isInternetConnected = 1
    End If
    IsConnectionON = isInternetConnected
End Function
