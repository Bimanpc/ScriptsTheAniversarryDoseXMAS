Dim num1, num2, op, result

num1 = CDbl(InputBox("Πρώτος αριθμός:", "Calculator"))
op = InputBox("Πράξη (+,-,*,/):", "Calculator")
num2 = CDbl(InputBox("Δεύτερος αριθμός:", "Calculator"))

Select Case op
    Case "+"
        result = num1 + num2
    Case "-"
        result = num1 - num2
    Case "*"
        result = num1 * num2
    Case "/"
        If num2 <> 0 Then
            result = num1 / num2
        Else
            MsgBox "Δεν επιτρέπεται διαίρεση με το μηδέν!", vbCritical
            WScript.Quit
        End If
    Case Else
        MsgBox "Άγνωστη πράξη!", vbCritical
        WScript.Quit
End Select

MsgBox "Αποτέλεσμα: " & result, vbInformation, "Calculator"
