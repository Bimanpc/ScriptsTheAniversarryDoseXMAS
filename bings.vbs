Set objIP = CreateObject( "SScripting.IPNetwork" )
strIP = objIP.DNSLookup( "www.bing.com" )
WScript.Echo "IP address of www.bing.com: " & strIP
Set objIP = Nothing