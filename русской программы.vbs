<FORM NAME=forma>
<INPUT TYPE="text" NAME="text1"><BR>
<INPUT TYPE="text" NAME="text2"><BR>
<INPUT TYPE="button" NAME="knopka"
VALUE="Спасйьо" OnClick=copyfun()>
</FORM>

<SCRIPT LANGUAGE="VBScript">
sub copyfun
  dim copytext
  copytext=document.forma.text1.value
  document.forma.text2.value=copytext
end sub
</SCRIPT>