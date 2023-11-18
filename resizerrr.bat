@echo off
setlocal enabledelayedexpansion

REM Set the path to the ImageMagick convert executable
set "convertPath=C:\Program Files\ImageMagick-7.0.11-Q16-HDRI\convert.exe"

REM Set the input and output directories
set "inputDir=C:\Path\To\Input\Directory"
set "outputDir=C:\Path\To\Output\Directory"

REM Set the desired width and height
set "width=800"
set "height=600"

REM Loop through each file in the input directory
for %%i in ("%inputDir%\*.*") do (
    REM Get the file name and extension
    set "fileName=%%~ni"
    set "fileExt=%%~xi"

    REM Build the output file path
    set "outputPath=!outputDir!\!fileName!_resized!width!x!height!!fileExt!"

    REM Resize the image using ImageMagick
    "%convertPath%" "%%i" -resize !width!x!height! "!outputPath!"
)

echo Images resized successfully.
pause
