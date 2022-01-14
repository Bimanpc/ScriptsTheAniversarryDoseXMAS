:: A batch file to check for network problems.
ECHO OFF
:: View network connection details
ipconfig /all
:: Check if geeksforgeeks.com is reachable
ping bing.com
:: Run a traceroute to check the route to geeksforgeeks.com
tracert bing.com
PAUSE