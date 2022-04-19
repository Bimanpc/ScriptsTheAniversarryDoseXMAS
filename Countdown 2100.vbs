<html>
<head>
</head>
<body>
<script type="text/vbscript">
Option Explicit

Dim newCentury
newCentury=CDate("1/1/2100 00:00:00")
document.write ("<h1>Countdown to  year 2100 (a new century!)</h1>")
document.write(DateDiff("yyyy", Now(), newCentury) & " years")
document.write("<br />" & DateDiff("m", Now(), newCentury) & " months")
document.write("<br />" & DateDiff("d", Now(), newCentury) & " days")

</script>
</body>
</html>