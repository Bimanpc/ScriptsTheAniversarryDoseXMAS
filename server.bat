@echo off
:: This batch script sets up a simple Flask web server

:: Check if Python is installed
python --version 2>&1 | find "Python" >nul
if %errorlevel% neq 0 (
    echo Python is not installed. Please install Python and try again.
    pause
    exit /b
)

:: Install Flask if not already installed
python -m pip show flask >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Flask...
    python -m pip install flask
)

:: Create a simple Flask app
echo Creating a simple Flask app...
(
echo from flask import Flask
echo app = Flask(__name__)
echo.
echo ^@app.route('/')
echo def home():
echo     return "Hello, this is a simple AI web server!"
echo.
echo if __name__ == '__main__':
echo     app.run(debug=True)
) > app.py

:: Run the Flask app
echo Starting the Flask web server...
python app.py
