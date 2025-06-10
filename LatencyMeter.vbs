' LatencyMeter.vbs
' A simple VBScript to measure network latency using the Ping command

host = InputBox("Enter the host name or IP address to ping:", "Latency Meter", "www.example.com")
if host = "" then
    WScript.Quit
end if

Set objShell = WScript.CreateObject("WScript.Shell")
Set objExec = objShell.Exec("ping -n 1 " & host)

strPingResults = objExec.StdOut.ReadAll()

' Extract the latency from the ping results
Set regEx = New RegExp
regEx.Pattern = "time=(\d+)ms"
regEx.IgnoreCase = True
Set matches = regEx.Execute(strPingResults)

If matches.Count > 0 Then
    latency = matches(0).SubMatches(0)
    MsgBox "Latency to " & host & " is " & latency & " ms", vbInformation, "Latency Meter"
Else
    MsgBox "Could not measure latency. Check the host name and try again.", vbExclamation, "Latency Meter"
End If
