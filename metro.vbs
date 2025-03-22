' VBScript to monitor internet usage

' Constants for network interface
Const NETWORK_INTERFACE = "Your Network Interface Name" ' e.g., "Ethernet" or "Wi-Fi"

' Function to get network statistics
Function GetNetworkStats(interfaceName)
    Dim objWMIService, colItems, objItem
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
    Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_Tcpip_NetworkInterface WHERE Name = '" & interfaceName & "'")

    For Each objItem In colItems
        GetNetworkStats = objItem.BytesTotalPerSec
    Next
End Function

' Main script
Dim initialBytes, currentBytes, bytesUsed
Dim startTime, currentTime

' Get initial bytes count
initialBytes = GetNetworkStats(NETWORK_INTERFACE)
startTime = Now

' Monitor usage every 5 seconds
Do
    WScript.Sleep 5000 ' Sleep for 5 seconds
    currentBytes = GetNetworkStats(NETWORK_INTERFACE)
    currentTime = Now

    ' Calculate bytes used
    bytesUsed = currentBytes - initialBytes

    ' Output the usage
    WScript.Echo "Time: " & currentTime
    WScript.Echo "Bytes Used: " & bytesUsed

    ' Update initial bytes count
    initialBytes = currentBytes
Loop
