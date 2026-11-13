@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Pocket Realms - Build Mod

echo ============================================
echo       POCKET REALMS - MOD BUILDER
echo       Minecraft 1.21.1 / NeoForge 21.1.265
echo ============================================
echo.

where java >nul 2>nul
if errorlevel 1 (
  echo ERROR: Java was not found. Install a 64-bit Java 21 JDK first.
  pause
  exit /b 1
)
where javac >nul 2>nul
if errorlevel 1 (
  echo ERROR: javac was not found. Your launcher Java may be runtime-only.
  echo Install a full 64-bit Java 21 JDK, then run this file again.
  pause
  exit /b 1
)

java -version 2>&1 | findstr /C:"21." >nul
if errorlevel 1 (
  echo WARNING: Java 21 was not detected. Gradle needs a Java 21 JDK.
  echo Your Minecraft launcher Java runtime may not include the compiler.
  echo Install a 64-bit Java 21 JDK if the build fails.
  echo.
)

set "TOOLS=%~dp0.tools"
set "GRADLE_HOME=%TOOLS%\gradle-9.2.1"
set "GRADLE_ZIP=%TOOLS%\gradle-9.2.1-bin.zip"

if not exist "%GRADLE_HOME%\bin\gradle.bat" (
  echo Gradle 9.2.1 is not installed in this project yet.
  echo Downloading Gradle. This is a one-time setup step.
  if not exist "%TOOLS%" mkdir "%TOOLS%"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-9.2.1-bin.zip' -OutFile '%GRADLE_ZIP%'; Expand-Archive -LiteralPath '%GRADLE_ZIP%' -DestinationPath '%TOOLS%' -Force"
  if errorlevel 1 (
    echo ERROR: Could not download Gradle. Check your internet connection and try again.
    pause
    exit /b 1
  )
)

echo.
echo Building Pocket Realms. First build downloads NeoForge and Minecraft libraries.
echo This may take a while on the first run.
echo.
call "%GRADLE_HOME%\bin\gradle.bat" --no-daemon build
if errorlevel 1 (
  echo.
  echo BUILD FAILED. Copy the full error text and send it for debugging.
  pause
  exit /b 1
)

echo.
echo ============================================
echo BUILD SUCCESSFUL!
echo Your mod JAR is in:
echo build\libs\pocketrealms-0.1.0-alpha.jar
echo ============================================
echo.
pause
