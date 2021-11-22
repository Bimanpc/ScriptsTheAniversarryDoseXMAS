<html>
<head>

<script type="text/vbscript">
Dim name, length
name = InputBox("Enter your Name Geeksz")
length = Len(name)’Gives length of the input string

For i = 1 To length
  txt = Mid(name,i,1)'Returns a specified number of characters from a string, the first parameter is the string, second parameter is the starting position and third parameter is the number of characters to return
  If txt="a" or txt="A" or txt="e" or txt="E" or txt="i" or txt="I" or txt="o" or txt="O" or txt="u" or txt="U" Then 
  counter = counter+1
  End If
Next
document.write("Hay Geeksz " & name & "!!!Your name contains " & counter & " vowels.")
</script>

</head>
<body>

</body>
</html>