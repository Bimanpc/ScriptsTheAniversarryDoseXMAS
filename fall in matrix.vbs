' Matrix.vbs
' A simple script to create a Matrix-like effect

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("MatrixEffect.txt", True)

Do
    Randomize
    strMatrix = ""
    
    ' Create a random string of characters/numbers
    For i = 1 To 60
        intCharType = Int((3 * Rnd) + 1)
        
        Select Case intCharType
            Case 1 ' Random number
                strMatrix = strMatrix & Chr(Int((10 * Rnd) + 48))
            Case 2 ' Random uppercase letter
                strMatrix = strMatrix & Chr(Int((26 * Rnd) + 65))
            Case 3 ' Random lowercase letter
                strMatrix = strMatrix & Chr(Int((26 * Rnd) + 97))
        End Select
    Next
    
    ' Print the string to the console
    objShell.Popup strMatrix, 0, "Matrix Effect", 0 + 64
    
    ' Write the string to a file
    objFile.WriteLine strMatrix
    
    ' Control the speed of the effect
    WScript.Sleep 100

Loop
