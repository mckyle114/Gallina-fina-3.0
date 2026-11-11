@echo off
setlocal
cd /d "%~dp0"

if not exist "audio" mkdir "audio"

if "%ELEVENLABS_API_KEY%"=="" (
  echo.
  echo ElevenLabs API key is not set in this Command Prompt.
  echo Paste it below. It is only used locally by this script.
  set /p ELEVENLABS_API_KEY=API key: 
)

if "%ELEVENLABS_API_KEY%"=="" (
  echo No API key entered. Nothing was generated.
  pause
  exit /b 1
)

echo.
echo Generating Cruce Espanol professional audio...
echo Existing files will be skipped so you can safely rerun this script.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate_audio.ps1"

if errorlevel 1 (
  echo.
  echo Audio generation stopped because an error occurred.
  echo Check your ElevenLabs API key, plan limits, and internet connection.
) else (
  echo.
  echo Finished. Keep the audio folder next to cruce_espanol_niveles.html.
)

pause
