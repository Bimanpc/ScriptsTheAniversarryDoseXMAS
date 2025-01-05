@echo off
setlocal

REM Path to the diskspd tool
set DISKSPD_PATH=C:\path\to\diskspd.exe

REM Path to the test file
set TEST_FILE=C:\path\to\testfile.dat

REM Size of the test file in MB
set TEST_FILE_SIZE=1024

REM Duration of the test in seconds
set TEST_DURATION=10

REM Create the test file
echo Creating test file...
fsutil file createnew %TEST_FILE% %TEST_FILE_SIZE%

REM Run the read speed test
echo Running read speed test...
%DISKSPD_PATH% -b4K -d%TEST_DURATION% -o32 -t4 -W0 -c1G %TEST_FILE%

REM Run the write speed test
echo Running write speed test...
%DISKSPD_PATH% -b4K -d%TEST_DURATION% -o32 -t4 -W100 -c1G %TEST_FILE%

REM Clean up the test file
echo Cleaning up...
del %TEST_FILE%

echo Speed test completed.
pause
