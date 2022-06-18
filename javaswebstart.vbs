Set objJava = CreateObject( "JavaWebStart.isInstalled" )
strIP = objJava.dnsResolve( "www.bing.com" )
WScript.Echo "IP address  www.bing.com: " & strIP
Set objJava = Nothing