echo "************************************************"
echo "Hello Geekz!"
echo "Vasiliy 2.0: No Suffix"
echo "************************************************"
echo "Powered by Vasiya"
echo "####################################"
#!/bin/bash
x=$(( $1 * 10 ))
while [ $x -gt 0 ] do
sleep $1
echo "No suffix present! Wait for $1 seconds"
x=$(( $x - $1 ))
done
echo "Done!!"