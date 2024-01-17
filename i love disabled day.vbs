' Declare a variable to store the message
Dim message
message = "Happy Equality Day! Let's celebrate diversity and inclusion for all."

' Declare a variable to store the title
Dim title
title = "Equality Day"

' Declare a variable to store the icon and button options
Dim options
options = 64 ' Information icon
options = options + 1 ' OK button only

' Display the message box using the MsgBox function
Dim response
response = MsgBox(message, options, title)
