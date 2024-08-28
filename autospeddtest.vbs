Dim objShell, strHost, strCmd, objExec, strOutput
strHost = "8.8.8.8" 'Google DNS, replace with any other IP/hostname

Set objShell = CreateObject("WScript.Shell")
strCmd = "ping -n 4 " & strHost

Set objExec = objShell.Exec(strCmd)
Do While Not objExec.StdOut.AtEndOfStream
    strOutput = objExec.StdOut.ReadLine()
    WScript.Echo strOutput
Loop
