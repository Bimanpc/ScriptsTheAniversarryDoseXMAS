' Save this file as GreekMsgBox.vbs
' IMPORTANT: Save the file in UTF-16 LE encoding (Unicode)

Option Explicit

Dim title, message

title = "Εφαρμογή MSXBOX"
message = "Γεια σας! Αυτό είναι ένα μήνυμα στα Ελληνικά."

MsgBox message, vbInformation + vbOKOnly, title
