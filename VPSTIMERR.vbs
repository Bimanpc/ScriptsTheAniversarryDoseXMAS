' countdown.vbs

Dim secondsLeft, message
secondsLeft = InputBox("Πόσα δευτερόλεπτα να μετρήσει αντίστροφα;", "Αντίστροφη Μέτρηση")

If Not IsNumeric(secondsLeft) Or secondsLeft <= 0 Then
    MsgBox "Παρακαλώ εισάγετε έναν έγκυρο αριθμό.", vbExclamation
    WScript.Quit
End If

Do While secondsLeft > 0
    message = "Απομένουν " & secondsLeft & " δευτερόλεπτα..."
    WScript.StdOut.Write message & vbCrLf
    WScript.Sleep 1000 ' 1000 ms = 1 δευτερόλεπτο
    secondsLeft = secondsLeft - 1
Loop

MsgBox "Τέλος χρόνου!", vbInformation
