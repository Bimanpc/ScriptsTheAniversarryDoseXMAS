Option Explicit

Dim objWMI, colAdapters, objAdapter
Set objWMI = GetObject("winmgmts:\\.\root\CIMV2")
Set colAdapters = objWMI.ExecQuery( _
    "SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True" _
)

For Each objAdapter In colAdapters
    WScript.Echo "Adapter: " & objAdapter.Description

    If IsArray(objAdapter.IPAddress) Then
        Dim i
        For i = LBound(objAdapter.IPAddress) To UBound(objAdapter.IPAddress)
            WScript.Echo "  IP Address(" & i & "): " & objAdapter.IPAddress(i)
        Next
    End If

    If IsArray(objAdapter.IPSubnet) Then
        WScript.Echo "  Subnet Mask: " & Join(objAdapter.IPSubnet, ", ")
    End If

    If IsArray(objAdapter.DefaultIPGateway) Then
        WScript.Echo "  Gateway: " & Join(objAdapter.DefaultIPGateway, ", ")
    End If

    If IsArray(objAdapter.DNSServerSearchOrder) Then
        WScript.Echo "  DNS Servers: " & Join(objAdapter.DNSServerSearchOrder, ", ")
    End If

    WScript.Echo String(40, "-")
Next
