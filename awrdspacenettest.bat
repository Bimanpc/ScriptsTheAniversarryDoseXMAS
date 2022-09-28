:: This batch file checks for network connection problems
:: and saves the output to .txt file.
ECHO OFF
:: View the network connection details
ipconfig /all >>  results.txt
:: Check if Awardspace.net is reachable
ping awardspace.net >> results.txt
:: Run a traceroute to check the route to Google.com
tracert awardspace.net >> results.txt