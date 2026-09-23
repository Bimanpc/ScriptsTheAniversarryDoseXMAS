Option Explicit

Dim text, speaker, voices

Set speaker = CreateObject("SAPI.SpVoice")
Set voices = speaker.GetVoices()

text = InputBox("Enter text to speak:", "Text-to-Speech")

If text <> "" Then
    If voices.Count > 0 Then
        Set speaker.Voice = voices.Item(0)
    End If

    speaker.Rate = 0      ' Speed (-10 to 10)
    speaker.Volume = 100  ' Volume (0 to 100)

    speaker.Speak text
End If

Set voices = Nothing
Set speaker = Nothing
