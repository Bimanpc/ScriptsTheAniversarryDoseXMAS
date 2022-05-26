<html>
<head>
</head>
<body>
<script type="text/vbscript">
Option Explicit

Dim newCentury
newCentury=CDate("1/1/2030 00:00:00")

document.write ("<h1>Countdown to the year 2030 (th end of hellinicon!)</h1>")

document.write(DateDiff("yyyy", Now(), newCentury) & " years")

document.write("<br />" & DateDiff("m", Now(), newCentury) & " months")

document.write("<br />" & DateDiff("d", Now(), newCentury) & " days")

document.write("<br />" & DateDiff("h", Now(), newCentury) & " hours")

document.write("<br />" & DateDiff("n", Now(), newCentury) & " minutes")

document.write("<br />" & DateDiff("s", Now(), newCentury) & " seconds")
</script>
</body>
</html>