Sub MsgBoxInformationIcon()
Result = MsgBox("Want Go @ Bouzoukia ?", vbYesNo + vbQuestion)
If Result = vbYes Then
MsgBox "You clicked Yes GO !!!"
Else: MsgBox "You clicked No al Shitir!!!"
End If
End Sub