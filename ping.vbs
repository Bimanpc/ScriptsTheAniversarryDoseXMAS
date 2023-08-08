strComputer = "localhost"

Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("ping -n 1 " & strComputer)

Do While Not objExec.StdOut.AtEndOfStream
    strText = objExec.StdOut.ReadLine()
    If InStr(strText, "Reply") Then
        WScript.Echo "Ping success....."
    End If
Loop
