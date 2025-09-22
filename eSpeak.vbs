<!-- Save as: grc_tts.hta -->
<html>
<head>
  <title>Ancient Greek TTS</title>
  <hta:application id="grcTTS" border="thin" caption="yes" showintaskbar="yes" />
  <script language="vbscript">
    Sub SpeakGRC()
      Dim text, rate, pitch, wavOut, cmd, shell
      text = document.getElementById("txt").value
      If Len(text) = 0 Then MsgBox "Enter Ancient Greek text": Exit Sub
      rate = document.getElementById("rate").value
      pitch = document.getElementById("pitch").value
      wavOut = GetAbsolutePath(".") & "\grc_output.wav"
      cmd = "espeak -v grc -s " & rate & " -p " & pitch & " -w """ & wavOut & """ """ & text & """"
      Set shell = CreateObject("WScript.Shell")
      shell.Run cmd, 0, True
      shell.Run """" & wavOut & """", 1, False
    End Sub

    Function GetAbsolutePath(rel)
      Dim fso: Set fso = CreateObject("Scripting.FileSystemObject")
      GetAbsolutePath = fso.GetAbsolutePathName(rel)
    End Function
  </script>
</head>
<body style="font-family:Segoe UI; margin:14px;">
  <div><b>Ancient Greek text:</b></div>
  <textarea id="txt" style="width:380px;height:120px;"></textarea>
  <div style="margin-top:8px;">
    Rate: <input id="rate" type="number" value="140" style="width:60px;">
    Pitch: <input id="pitch" type="number" value="50" style="width:60px;">
    <button onclick="SpeakGRC()">Speak</button>
  </div>
</body>
</html>
