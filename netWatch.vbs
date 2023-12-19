' NetworkWatcher.vbs
' Simple VBScript to watch for new network connections using WMI

Set objWMIService = GetObject("winmgmts:\\.\root\CIMv2")
Set colEvents = objWMIService.ExecNotificationQuery _
    ("SELECT * FROM Win32_NetworkConnectionNotification")

WScript.Echo "Network Watcher Script Running..."

Do
    Set objEvent = colEvents.NextEvent()
    
    If objEvent.EventType = 1 Then
        ' Event Type 1 indicates a new network connection
        WScript.Echo "New Network Connection:"
        WScript.Echo "Local Name: " & objEvent.LocalName
        WScript.Echo "Remote Name: " & objEvent.RemoteName
        WScript.Echo "Local Type: " & objEvent.LocalType
        WScript.Echo "Remote Type: " & objEvent.RemoteType
        WScript.Echo "Connection Status: " & objEvent.ConnectionStatus
        WScript.Echo "----------------------------------------"
    End If
Loop
