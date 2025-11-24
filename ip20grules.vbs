' Get first enabled IPv4 address from local machine
Option Explicit
Dim svc, nic, ipAddr
Set svc = GetObject("winmgmts:").InstancesOf("Win32_NetworkAdapterConfiguration")
For Each nic In svc
  If nic.IPEnabled Then
    If IsArray(nic.IPAddress) Then
      ipAddr = nic.IPAddress(0)
      Exit For
    End If
  End If
Next
If ipAddr = "" Then ipAddr = "127.0.0.1"
WScript.Echo "Local IP: " & ipAddr
