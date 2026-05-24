#!/bin/bash

sudo umount /mnt/netdrive 2>/dev/null

sudo mount -t cifs //SERVER/SHARE /mnt/netdrive \
   -o username=YOURUSER,password=YOURPASS,vers=3.0

echo "Network drive mounted."
