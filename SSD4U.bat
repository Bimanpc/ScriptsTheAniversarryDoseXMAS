@echo off
for /f "tokens=2 delims==" %%A in (
  'wmic /namespace:\\root\Microsoft\Windows\Storage PATH MSFT_PhysicalDisk Where "MediaType='4' And SpindleSpeed='0'" Get Temperature /value'
) do set "SSD_Temp=%%~A"
echo The SSD temperature is %SSD_Temp% degrees Celsius.
