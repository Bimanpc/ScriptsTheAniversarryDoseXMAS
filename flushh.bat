@echo off
:: Batch script to flush the DNS cache
echo Flushing DNS cache...
ipconfig /flushdns
echo DNS cache has been flushed.
pause
