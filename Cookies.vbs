<html>
   <head>
      <script type = "text/vbscript">
         Function WriteCookie
            If document.myform.customer.value = "" Then
               msgbox "Enter one value!!"
            Else
               cookievalue = (document.myform.customer.value)
               document.cookie = "name = " + cookievalue
               msgbox "Setting Cookies : " & "name = " & cookievalue
            End If
         End Function
      </script>
   </head>
   
   <body>
      <form name = "myform" action = "">
         Enter name: <input type = "text" name = "customer"/>
         <input type = "button" value = "Set Cookie" onclick = "WriteCookie()"/>
      </form>
   </body>
</html>