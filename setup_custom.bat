@echo off
REM Custom Setup Script for Xboard-Mihomo Client (Windows)
REM This script helps you set up the project with your custom configuration

echo ==================================
echo Xboard-Mihomo Client Setup
echo ==================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed. Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Check if Dart is installed
where dart >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Dart is not installed. Please install Dart first.
    pause
    exit /b 1
)

echo [OK] Flutter and Dart are installed
echo.

REM Step 1: Initialize submodules
echo Step 1: Initializing Git submodules...
git submodule update --init --recursive
if %errorlevel% neq 0 (
    echo [ERROR] Failed to initialize submodules
    pause
    exit /b 1
)
echo [OK] Submodules initialized successfully
echo.

REM Step 2: Generate SDK code
echo Step 2: Generating XBoard SDK code...
cd lib\sdk\flutter_xboard_sdk

call flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install SDK dependencies
    cd ..\..\..
    pause
    exit /b 1
)
echo [OK] SDK dependencies installed

call dart run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo [ERROR] Failed to generate SDK code
    cd ..\..\..
    pause
    exit /b 1
)
echo [OK] SDK code generated successfully

cd ..\..\..
echo.

REM Step 3: Install project dependencies
echo Step 3: Installing project dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install project dependencies
    pause
    exit /b 1
)
echo [OK] Project dependencies installed
echo.

REM Step 4: Check configuration files
echo Step 4: Checking configuration files...
set CONFIG_NEEDED=0

if not exist "config.json" (
    echo [WARNING] config.json not found
    echo    Please create config.json from config.example.json
    set CONFIG_NEEDED=1
)

if not exist "assets\config\xboard.config.yaml" (
    echo [WARNING] xboard.config.yaml not found
    echo    Please create xboard.config.yaml from xboard.config.example.yaml
    set CONFIG_NEEDED=1
)

if %CONFIG_NEEDED% equ 1 (
    echo.
    set /p response="Configuration files are missing. Create them now? (y/n): "
    if /i "%response%"=="y" (
        if not exist "config.json" (
            copy config.example.json config.json
            echo [OK] Created config.json (please edit it with your settings)
        )
        if not exist "assets\config\xboard.config.yaml" (
            copy assets\config\xboard.config.example.yaml assets\config\xboard.config.yaml
            echo [OK] Created xboard.config.yaml (please edit it with your settings)
        )
    )
)
echo.

REM Step 5: Summary
echo ==================================
echo Setup Complete!
echo ==================================
echo.
echo Next steps:
echo 1. Edit config.json with your backend URLs
echo 2. Edit assets\config\xboard.config.yaml with your settings
echo 3. Upload config.json to your hosting (GitHub/Gitee/CDN)
echo 4. Update the remote_config.sources[0].url in xboard.config.yaml
echo 5. Build the app:
echo    - Android: dart setup.dart android
echo    - Windows: dart setup.dart windows --arch amd64
echo.
echo For development:
echo    flutter run -d windows
echo.
echo Documentation: See CUSTOMIZATION_GUIDE.md
echo.

pause
