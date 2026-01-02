' WifiLatencyStop.vbs
' Simple Wi‑Fi latency monitor you can stop any time.

Option Explicit

' ===== CONFIGURATION =====
Dim TARGET_HOST      : TARGET_HOST      = "8.8.8.8"   ' Change to your preferred host (e.g. gateway IP)
Dim PING_COUNT       : PING_COUNT       = 1           ' Number of echo requests per check
Dim CHECK_INTERVAL   : CHECK_INTERVAL   = 3000        ' Milliseconds between checks
Dim HIGH_LATENCY_MS  : HIGH_LATENCY_MS  = 100         ' Threshold for "high" latency in ms
Dim SHOW_POPUPS      : SHOW_POPUPS      = True        ' Set False to disable popups (script will still run)
' =========================

Dim wsh, shell, continueMonitoring
Set wsh   = CreateObject("WScript.Shell")
Set shell = CreateObject("WScript.Shell")

continueMonitoring = True

Dim userMsg
userMsg = "Wi‑Fi latency monitor started." & vbCrLf & vbCrLf & _
          "Target: " & TARGET_HOST & vbCrLf & _
          "High latency threshold: " & HIGH_LATENCY_MS & " ms" & vbCrLf & vbCrLf & _
          "Click OK to start monitoring or Cancel to exit."

If SHOW_POPUPS Then
    Dim r
    r = MsgBox(userMsg, vbOKCancel + vbInformation, "Wi‑Fi Latency Monitor")
    If r = vbCancel Then
        WScript.Quit 0
    End If
End If

Do While continueMonitoring
    Dim latencyMs
    latencyMs = GetPingLatencyMs(TARGET_HOST, PING_COUNT)

    Dim msg, title, buttons
    title = "Wi‑Fi Latency Monitor"
    buttons = vbOKCancel + vbInformation

    If latencyMs < 0 Then
        msg = "No response from " & TARGET_HOST & "." & vbCrLf & _
              "Check your Wi‑Fi connection." & vbCrLf & vbCrLf & _
              "Click OK to keep monitoring or Cancel to stop."
    ElseIf latencyMs > HIGH_LATENCY_MS Then
        msg = "High latency detected!" & vbCrLf & _
              "Latency: " & latencyMs & " ms" & vbCrLf & vbCrLf & _
              "Click OK to keep monitoring or Cancel to stop."
        buttons = vbOKCancel + vbExclamation
    Else
        msg = "Latency OK." & vbCrLf & _
              "Latency: " & latencyMs & " ms" & vbCrLf & vbCrLf & _
              "Click OK to keep monitoring or Cancel to stop."
    End If

    If SHOW_POPUPS Then
        Dim resp
        resp = MsgBox(msg, buttons, title)
        If resp = vbCancel Then
            continueMonitoring = False
            Exit Do
        End If
    End If

    WScript.Sleep CHECK_INTERVAL
Loop

If SHOW_POPUPS Then
    MsgBox "Wi‑Fi latency monitor stopped.", vbInformation, "Wi‑Fi Latency Monitor"
End If

WScript.Quit 0

' =========================
' Function: GetPingLatencyMs
' Returns latency in ms (Long), or -1 if no reply.
' =========================
Function GetPingLatencyMs(host, count)
    Dim exec, line, tmpFile, fso, outFile
    Dim cmd
    cmd = "cmd /c ping -n " & CStr(count) & " " & host

    Set exec = wsh.Exec(cmd)

    Dim output
    output = ""
    Do While Not exec.StdOut.AtEndOfStream
        line = exec.StdOut.ReadLine()
        output = output & line & vbCrLf
    Loop

    GetPingLatencyMs = ParseLatencyFromPing(output)
End Function

' =========================
' Function: ParseLatencyFromPing
' Parses ping output and returns latency in ms or -1 if failed.
' =========================
Function ParseLatencyFromPing(pingOutput)
    Dim lines, i, line
    Dim latencyMs
    latencyMs = -1

    lines = Split(pingOutput, vbCrLf)
    For i = 0 To UBound(lines)
        line = Trim(lines(i))

        ' Windows ping typical line:
        ' "Reply from 8.8.8.8: bytes=32 time=20ms TTL=117"
        If InStr(1, LCase(line), "time=") > 0 Then
            Dim posTime, posMs, timePart
            posTime = InStr(1, LCase(line), "time=")
            If posTime > 0 Then
                timePart = Mid(line, posTime + 5) ' skip "time="
                posMs = InStr(1, LCase(timePart), "ms")
                If posMs > 0 Then
                    timePart = Left(timePart, posMs - 1)
                    timePart = Trim(timePart)
                    If IsNumeric(timePart) Then
                        latencyMs = CLng(timePart)
                        Exit For
                    End If
                End If
            End If
        End If
    Next

    ParseLatencyFromPing = latencyMs
End Function
