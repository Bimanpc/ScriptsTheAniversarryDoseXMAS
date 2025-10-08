' Greek Narrator using SAPI.SpVoice
Dim speaker, text
Set speaker = CreateObject("SAPI.SpVoice")

' Optional: set Greek voice if installed
' For example: "Microsoft Stefanos Desktop" or other installed Greek TTS voice
For Each v In speaker.GetVoices
    If InStr(v.GetDescription, "Greek") > 0 Then
        speaker.Voice = v
        Exit For
    End If
Next

' Sample Greek text (replace with LLM output)
text = "Καλησπέρα σας. Είμαι ένας αφηγητής που μιλάει ελληνικά."

' Speak the text
speaker.Speak text
