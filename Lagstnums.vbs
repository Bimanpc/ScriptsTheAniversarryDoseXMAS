' File:  largestNum.vbs
'
' Purpose:  input three numbers and figure out the maximum of the numbers.
'
' Lessons
' -- the if/then/else construct 
' -- be careful when working with numbers 
' -- continue code to the next line by using the underscore
' -- parameters are separated by a comma

Option Explicit                     ' recall force explicit var declaration

Dim largestNum                      ' variable for largest number
Dim num1, num2, num3                ' variables for the three input numbers

num1 = InputBox("Please enter the first number: ")
num2 = InputBox("Please enter the second number: ")
num3 = InputBox("Please enter the third number: ")

' check to make sure all input are "numeric" - integer/float/double
If IsNumeric(num1) and IsNumeric(num2) and IsNumeric(num3) Then
    ' MsgBox is a subroutine, the first parameter is the "prompt"
    '
    ' if the last character of the line is an underscore, then the line of
    ' code is continued to the next line (CANNOT put comment here)
    '
    ' the second parameter is what button to put on the MsgBox
    '
    ' the third parameter is the "title" for the MsgBox
    '
    ' note, there are more parameters for MsgBox, but we choose to use defaults
    MsgBox "You have entered: " & num1 & " " & num2 & " " & num3, _
           vbOKOnly,  "Entered Values"

    ' the numbers can be integers or floating point number (have dec point),
    ' compare them as "Double" (or floating point numbers)
    largestNum = num1
    If CDbl(num2) > CDbl(largestNum) Then
        largestNum = num2
    End If

    If CDbl(num3) > CDbl(largestNum) Then
        largestNum = num3
    End If

    MsgBox "The largest number is: "  & largestNum, vbOKOnly, _
        "Largest Number"
Else
    MsgBox "You must enter three numbers! Try Again", vbOKOnly, "Invalid Input"
End If