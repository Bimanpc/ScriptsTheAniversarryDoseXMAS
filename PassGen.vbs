Dim intMax, iLoop, k, intValue, strChar, strName, intNum

' Specify the alphabet of characters to use.
Const Chars = "abcdefghijklmnopqrstuvwxyz"

' Specify length of names.
intMax = 10

' Specify number of names to generate.
intNum = 10

Randomize()
For iLoop = 1 To intNum
    strName = ""
    For k = 1 To intMax
        ' Retrieve random digit between 0 and 25 (26 possible characters).
        intValue = Fix(26 * Rnd())
        ' Convert to character in allowed alphabet.
        strChar = Mid(Chars, intValue + 1, 1)
        ' Build the name.
        strName = strName & strChar
    Next

' Number of Integers can be specified here

    Wscript.Echo strName & Int( ( 7789 - 7 + 889 ) * Rnd + 999 )
Next 