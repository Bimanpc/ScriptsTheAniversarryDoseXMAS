' AncientGreekTTS.vbs
' Speaks Ancient Greek text using Windows SAPI. Selects a Greek voice if available.
' Notes:
' - Windows typically provides Modern Greek voices (el-GR). Pronunciation will be modern, not ancient.
' - To influence pronunciation, you can use SAPI XML with phonemes, rate, and pitch.

Option Explicit

Dim text, useFile, fso, filePath, voiceName, rate, volume
Dim sapi, token, voices, i, chosen

'--------------- Configuration ---------------
' Set to True to read text from a file, False to use inline text below.
useFile   = False
filePath  = "C:\AncientGreek.txt"     ' Change when useFile=True
voiceName = ""                        ' e.g., "Microsoft Maria - Greek (Greece)"
rate      = 0                         ' -10..10 (negative = slower)
volume    = 100                       ' 0..100
'--------------- Ancient Greek sample ---------------
text = "Ἄνδρα μοι ἔννεπε, Μοῦσα, πολύτροπον, ὃς μάλα πολλὰ " & _
       "πλάγχθη, ἐπεί Τροίης ἱερὸν πτολίεθρον ἔπερσε."

' Read from file if enabled
If useFile Then
  Set fso = CreateObject("Scripting.FileSystemObject")
  If Not fso.FileExists(filePath) Then
    WScript.Echo "File not found: " & filePath
    WScript.Quit 1
  End If
  text = fso.OpenTextFile(filePath, 1, False, -1).ReadAll  ' -1 for Unicode
End If

' Create SAPI voice
Set sapi = CreateObject("SAPI.SpVoice")
sapi.Rate   = rate
sapi.Volume = volume

' Try to select a Greek voice (el-GR). Fallback if not found.
Set voices = sapi.GetVoices
chosen = False

' If a specific voice name is set, try it first
If Len(voiceName) > 0 Then
  For i = 0 To voices.Count - 1
    Set token = voices.Item(i)
    If LCase(token.GetDescription) = LCase(voiceName) Then
      Set sapi.Voice = token
      chosen = True
      Exit For
    End If
  Next
End If

' Otherwise, pick any voice that looks Greek by locale or description
If Not chosen Then
  For i = 0 To voices.Count - 1
    Set token = voices.Item(i)
    ' Check for el-GR in attributes or "Greek" in description
    If InStr(1, token.Id, "el-GR", vbTextCompare) > 0 _
       Or InStr(1, token.GetDescription, "Greek", vbTextCompare) > 0 _
       Or InStr(1, token.GetAttribute("Language"), "0408", vbTextCompare) > 0 Then
      Set sapi.Voice = token
      chosen = True
      Exit For
    End If
  Next
End If

If Not chosen Then
  WScript.Echo "No Greek voice found. Using default system voice."
End If

' Optional: SAPI XML to slow pace and adjust prosody for ancient feel
Dim xml
xml = "<sapi>" & _
        "<prosody rate='-2' volume='100'>" & _
        EscapeXml(text) & _
        "</prosody>" & _
      "</sapi>"

' Speak
sapi.Speak xml, 1  ' 1 = SVSFlagsAsync; remove if you prefer blocking
Do While sapi.Status.RunningState = 2 ' SRSEIsSpeaking
  WScript.Sleep 50
Loop

' Utility: basic XML escaping
Function EscapeXml(s)
  Dim t
  t = s
  t = Replace(t, "&", "&amp;")
  t = Replace(t, "<", "&lt;")
  t = Replace(t, ">", "&gt;")
  EscapeXml = t
End Function
