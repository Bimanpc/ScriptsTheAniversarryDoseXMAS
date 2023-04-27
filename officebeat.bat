:: This batch file checks for network connection problems
:: and saves the output to a .txt file.
ECHO OFF
:: View network connection details
ipconfig /all >>  results.txt
:: Check if office.com is reachable
ping office.com >> results.txt
:: Run a traceroute to check the route to office.com
tracert office.com >> results.txt