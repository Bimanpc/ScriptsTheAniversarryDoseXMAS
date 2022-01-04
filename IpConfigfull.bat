:: This batch file checks for network connection problems.
ECHO OFF
:: View network connection details
ipconfig /all
:: Check if bing.com is reachable
ping bing.com
:: Run a traceroute to check the route to bing.com
tracert bing.com
PAUSE