' NetworkInfoChanger.vbs
' Run with cscript.exe for console output
Option Explicit

Dim strAdapter, strIP, strMask, strGateway, strDNS
Dim objWMIService, colAdapters, objAdapter, ret

' === CONFIGURATION ===
strAdapter = "Ethernet"   ' Adapter name (check in ncpa.cpl)
strIP      = "192.168.1.100"
strMask    = "255.255.255.0"
strGateway = "192.168.1.1"
strDNS     = "8.8.8.8"

' === CONNECT TO WMI ===
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Set colAdapters = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True")

For Each objAdapter In colAdapters
    If InStr(objAdapter.Description, strAdapter) > 0 Then
        WScript.Echo "Configuring: " & objAdapter.Description

        ' Set static IP
        ret = objAdapter.EnableStatic(Array(strIP), Array(strMask))
        If ret = 0 Then WScript.Echo "IP set successfully"

        ' Set gateway
        ret = objAdapter.SetGateways(Array(strGateway))
        If ret = 0 Then WScript.Echo "Gateway set successfully"

        ' Set DNS
        ret = objAdapter.SetDNSServerSearchOrder(Array(strDNS))
        If ret = 0 Then WScript.Echo "DNS set successfully"

        Exit For
    End If
Next
