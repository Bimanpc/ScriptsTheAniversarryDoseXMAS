' cpu_bench.vbs - Minimal CPU benchmark in pure VBScript
Option Explicit

' ------------ Config ------------
Dim baseIter: baseIter = 3000000  ' You can override via CLI arg
If WScript.Arguments.Count > 0 Then
    On Error Resume Next
    baseIter = CLng(WScript.Arguments(0))
    If Err.Number <> 0 Or baseIter <= 0 Then baseIter = 3000000
    On Error GoTo 0
End If

Dim intIter:  intIter  = baseIter * 2
Dim floatIter:floatIter = baseIter
Dim strIter:  strIter  = baseIter \ 6
Dim dictIter: dictIter = baseIter \ 3

' ------------ Timing helpers ------------
Function NowMs()
    NowMs = Timer * 1000  ' milliseconds since midnight
End Function

Function ElapsedMs(startMs)
    Dim t: t = Timer * 1000
    ' Handle midnight rollover (Timer resets at 24h)
    If t < startMs Then t = t + 86400000
    ElapsedMs = t - startMs
End Function

' ------------ Warm-up (JIT-ish and cache effects) ------------
Sub WarmUp()
    Dim i, x
    x = 0
    For i = 1 To 500000
        x = x + (i And 7)
        x = x Xor i
        x = x * 3 - 1
        x = x + Sqr(i)
    Next
End Sub

' ------------ Bench sections ------------
Function BenchIntegerOps(iter)
    Dim i, x, startMs
    x = 0
    startMs = NowMs()
    For i = 1 To iter
        x = (x + i) And &H7FFFFFFF
        x = ((x * 3) Xor i) - 1
        x = x + (i Mod 7)
    Next
    BenchIntegerOps = ElapsedMs(startMs)
End Function

Function BenchFloatOps(iter)
    Dim i, y, r, startMs
    y = 0#
    Randomize 42
    startMs = NowMs()
    For i = 1 To iter
        r = Rnd
        ' VBScript has limited math: use Sqr, ^, simple mixes
        y = y + Sqr(i) * 0.5 + (i ^ 0.25) * 0.25 + r * 0.25
        y = y - (y * 0.0000001) ' keep value bounded
    Next
    BenchFloatOps = ElapsedMs(startMs)
End Function

Function BenchStringOps(iter)
    Dim i, s, startMs
    s = "abc"
    startMs = NowMs()
    For i = 1 To iter
        s = s & CStr(i And 15) & "x"
        If Len(s) > 64 Then s = Mid(s, 9, 48) ' slice to avoid huge growth
    Next
    BenchStringOps = ElapsedMs(startMs)
End Function

Function BenchDictionaryOps(iter)
    Dim i, d, k, v, startMs
    Set d = CreateObject("Scripting.Dictionary")
    d.CompareMode = 0 ' Binary compare
    startMs = NowMs()
    For i = 1 To iter
        k = "k" & (i And 65535)
        If Not d.Exists(k) Then d.Add k, i Else v = d(k)
        If (i And 1023) = 0 Then d.Remove k ' keep size manageable
    Next
    BenchDictionaryOps = ElapsedMs(startMs)
    Set d = Nothing
End Function

' ------------ Run ------------
WarmUp()

Dim tInt, tFlt, tStr, tDic
tInt = BenchIntegerOps(intIter)
tFlt = BenchFloatOps(floatIter)
tStr = BenchStringOps(strIter)
tDic = BenchDictionaryOps(dictIter)

' Operations per second (approx)
Dim opsInt, opsFlt, opsStr, opsDic
opsInt = (intIter)  / (tInt / 1000)
opsFlt = (floatIter)/ (tFlt / 1000)
opsStr = (strIter)  / (tStr / 1000)
opsDic = (dictIter) / (tDic / 1000)

' Composite score: weighted sum to balance very fast integer ops
Dim score
score = (opsInt * 0.4) + (opsFlt * 0.3) + (opsStr * 0.15) + (opsDic * 0.15)

' ------------ Output ------------
WScript.Echo "VBScript CPU Bench"
WScript.Echo "Base iterations: " & baseIter
WScript.Echo ""
WScript.Echo "Integer ops: " & intIter & " in " & FormatMs(tInt) & " ms | " & Round(opsInt) & " ops/s"
WScript.Echo "Float ops:   " & floatIter & " in " & FormatMs(tFlt) & " ms | " & Round(opsFlt) & " ops/s"
WScript.Echo "String ops:  " & strIter & " in " & FormatMs(tStr) & " ms | " & Round(opsStr) & " ops/s"
WScript.Echo "Dict ops:    " & dictIter & " in " & FormatMs(tDic) & " ms | " & Round(opsDic) & " ops/s"
WScript.Echo ""
WScript.Echo "Composite score: " & Round(score)

Function FormatMs(ms)
    If ms < 1 Then
        FormatMs = "0." & CStr(Int(ms * 1000)) ' sub-ms edge
    Else
        FormatMs = CStr(Int(ms))
    End If
End Function

Function Round(n)
    Round = CLng(n + 0.5)
End Function
