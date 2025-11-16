' byzantine_greek_tts_api.vbs
Option Explicit

Dim txt, apiUrl, apiKey, voiceId, req, fs, tmpFile, stream, wmp
Dim payload, responseBody

txt = InputBox("Εισαγωγή βυζαντινού ελληνικού κειμένου:", "AI TTS (Byzantine Greek)")
If Len(txt) = 0 Then WScript.Quit

' Configure your TTS API details
apiUrl  = "https://api.example.com/v1/tts"        ' Replace with your provider endpoint
apiKey  = "YOUR_API_KEY"                           ' Replace with your API key
voiceId = "YOUR_GREEK_BYZANTINE_VOICE_ID"          ' Replace with selected/custom voice

' Example JSON payload (adapt to your provider’s spec)
payload = _
    "{""text"":""" & EscapeJson(txt) & """," & _
    """voice_id"":""" & voiceId & """," & _
    """language"":""el-GR""," & _
    """format"":""mp3""," & _
    """settings"":{""pitch"":-2,""speaking_rate"":0.9,""style"":""chant""}}"

' Send request
Set req = CreateObject("MSXML2.XMLHTTP")
req.Open "POST", apiUrl, False
req.setRequestHeader "Content-Type", "application/json"
req.setRequestHeader "Authorization", "Bearer " & apiKey
req.send payload

If req.Status < 200 Or req.Status >= 300 Then
    MsgBox "TTS request failed: " & req.Status & " - " & req.responseText, vbCritical, "TTS Error"
    WScript.Quit
End If

' Save binary audio to a temp MP3
Set fs = CreateObject("Scripting.FileSystemObject")
tmpFile = fs.GetSpecialFolder(2) & "\byz_tts_" & Hex(Timer * 1000) & ".mp3"

' Use ADODB.Stream to write binary response
Set stream = CreateObject("ADODB.Stream")
stream.Type = 1 ' binary
stream.Open
' ResponseBody may be binary; for XMLHTTP, use responseBody via MSXML2.XMLHTTP60 or adopt responseStream if available
' Here we assume responseBody is binary-safe
stream.Write req.responseBody
stream.Position = 0
stream.SaveToFile tmpFile, 2 ' adSaveCreateOverWrite
stream.Close

' Play via Windows Media Player
Set wmp = CreateObject("WMPlayer.OCX")
wmp.URL = tmpFile
wmp.settings.autoStart = True

' Wait until playback starts (simple loop)
Do While wmp.playState = 0 ' wmppsUndefined
    WScript.Sleep 100
Loop

' Optional: cleanup after playback finishes (simple watcher)
Do While wmp.playState <> 1 ' wmppsStopped
    WScript.Sleep 500
Loop

' Remove temp file
On Error Resume Next
If fs.FileExists(tmpFile) Then fs.DeleteFile tmpFile, True
On Error GoTo 0

' --- Helpers ---
Function EscapeJson(s)
    Dim t
    t = s
    t = Replace(t, "\", "\\")
    t = Replace(t, """", "\""")
    t = Replace(t, vbCrLf, "\n")
    t = Replace(t, vbCr, "\n")
    t = Replace(t, vbLf, "\n")
    EscapeJson = t
End Function
