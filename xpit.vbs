Set objShell = CreateObject("WScript.Shell")
Do
    strTime = Now
    strTime = Hour(strTime) & ":" & Right("0" & Minute(strTime), 2) & ":" & Right("0" & Second(strTime), 2)
    objShell.SendKeys strTime
    WScript.Sleep 1000
    objShell.SendKeys "{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}"
Loop
