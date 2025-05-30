Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("ipconfig /all")

' Read the command output and display it
strOutput = objExec.StdOut.ReadAll()
WScript.Echo strOutput
