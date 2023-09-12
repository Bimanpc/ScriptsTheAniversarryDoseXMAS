@echo off
setlocal enabledelayedexpansion

:: List of URLs to check
set "urls=example.com google.com example.org"

:: Output file for results
set "output=output.txt"

:: Loop through each URL and check the HTTP status code
for %%url in (%urls%) do (
    set "url=%%url"
    curl -I "%%url%" > temp.txt

    :: Get the HTTP status code from the response header
    for /f "tokens=2" %%a in ('findstr /c:"HTTP" temp.txt') do (
        set "status=%%a"
        echo %%url%% - HTTP Status: !status! >> !output!
    )

    del temp.txt
)

echo SEO checks completed. Results are saved in %output%
