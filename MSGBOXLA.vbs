' Text2Speech MsgBox in Latin
Dim sapi, text
text = "Salve! Quomodo te habes?"   ' Latin phrase: "Hello! How are you?"

' Create the SAPI.SpVoice object for speech
Set sapi = CreateObject("SAPI.SpVoice")

' Speak the text aloud
sapi.Speak text

' Show the same text in a message box
MsgBox text, vbInformation, "Text2Speech Latin"
