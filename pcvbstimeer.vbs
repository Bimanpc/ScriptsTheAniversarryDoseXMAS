' Shutdown Timer App - VBS Script

Dim timeInSeconds
Dim message

timeInSeconds = InputBox("Σε πόσα δευτερόλεπτα θέλεις να κλείσει ο υπολογιστής;", "Χρονοδιακόπτης Τερματισμού")

If IsNumeric(timeInSeconds) Then
    message = "Ο υπολογιστής θα κλείσει σε " & timeInSeconds & " δευτερόλεπτα."
    MsgBox message, vbInformation, "Τερματισμός"
    Set shell = CreateObject("WScript.Shell")
    shell.Run "shutdown -s -t " & timeInSeconds
Else
    MsgBox "Παρακαλώ εισάγετε έναν έγκυρο αριθμό.", vbExclamation, "Σφάλμα"
End If
