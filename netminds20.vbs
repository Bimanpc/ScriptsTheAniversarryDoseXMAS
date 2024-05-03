Option Explicit

Dim strHost, objShell, objExec, strPingResults

' Hostname or IP address to ping
strHost = "www.bing.com"

Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("ping -n 3 " & strHost) ' Pinging 3 times, you can change this number as per your requirement

' Read the ping results
strPingResults = objExec.StdOut.ReadAll()

' Display the ping results
WScript.Echo "Ping results for " & strHost & ":" & vbCrLf & strPingResults
