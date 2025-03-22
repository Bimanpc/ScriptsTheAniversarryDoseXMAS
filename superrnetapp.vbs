' This script toggles the internet connection on or off

Set objShell = CreateObject("WScript.Shell")
Set objNetwork = CreateObject("WScript.Network")

' Check the current status of the internet connection
strConnection = "Local Area Connection" ' Change this to your connection name
Set colConnections = objNetwork.EnumNetworkDrives

For Each objConnection In colConnections
    If objConnection.Name = strConnection Then
        If objConnection.Status = 2 Then ' 2 means connected
            WScript.Echo "Disconnecting from the internet..."
            objNetwork.RemoveNetworkDrive objConnection.Name
            WScript.Echo "Disconnected."
        Else
            WScript.Echo "Connecting to the internet..."
            objNetwork.MapNetworkDrive objConnection.Name, objConnection.RemotePath
            WScript.Echo "Connected."
        End If
        Exit For
    End If
Next
