strPw = Password( "Enter your pass:" )
WScript.Echo "Your pass is: " & strPw

Function Password( myPrompt )
' This function hides a password while it is being typed.

    ' Standard housekeeping
    Dim objPassword

    ' Use ScriptPW.dll by creating an object
    Set objPassword = CreateObject( "ScriptPW.Password" )

    ' Display the prompt text
    WScript.StdOut.Write myPrompt

    ' Return the typed password
    Password = objPassword.GetPassword()

    ' Clear prompt
    WScript.StdOut.Write String( Len( myPrompt ), Chr( 8 ) ) _
                       & Space( Len( myPrompt ) ) _
                       & String( Len( myPrompt ), Chr( 8 ) )
End Function