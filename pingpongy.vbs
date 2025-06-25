Randomize
Dim playerScore, cpuScore, turn
playerScore = 0
cpuScore = 0
turn = "player"

WScript.Echo "Ας αρχίσουμε το Ping Pong!"
WScript.Echo "Πάτησε Enter για να χτυπήσεις την μπάλα όταν έρθει η σειρά σου."

Do While playerScore < 5 And cpuScore < 5
    If turn = "player" Then
        InputBox "Η σειρά σου! Πάτα OK για να χτυπήσεις την μπάλα."
        If Rnd < 0.8 Then
            WScript.Echo "Καλή επιστροφή! Ο υπολογιστής ετοιμάζεται..."
            turn = "cpu"
        Else
            WScript.Echo "Έχασες τη μπάλα! Σημείο για τον υπολογιστή."
            cpuScore = cpuScore + 1
            turn = "player"
        End If
    Else
        WScript.Sleep 1000
        If Rnd < 0.75 Then
            WScript.Echo "Ο υπολογιστής επέστρεψε την μπάλα. Η σειρά σου!"
            turn = "player"
        Else
            WScript.Echo "Ο υπολογιστής έχασε! Παίρνεις ένα πόντο."
            playerScore = playerScore + 1
            turn = "player"
        End If
    End If
    WScript.Echo "Σκορ: Παίκτης " & playerScore & " - Υπολογιστής " & cpuScore
Loop

If playerScore = 5 Then
    WScript.Echo "Συγχαρητήρια! Κέρδισες το παιχνίδι!"
Else
    WScript.Echo "Ο υπολογιστής κέρδισε. Καλή προσπάθεια!"
End If
