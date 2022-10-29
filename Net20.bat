//  Batch file to check network connection problems.
ECHO OFF

// View network connection details
IPCONFIG /all

// Check if geeksforgeeks.com is reachable
PING geeksforgeeks.com

// Run a traceroute to check the route to geeksforgeeks.com
TRACERT geeksforgeeks.com

PAUSE