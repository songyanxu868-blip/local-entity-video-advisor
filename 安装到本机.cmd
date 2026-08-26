@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-current-codex.ps1"
if errorlevel 1 (
  echo.
  echo Installation failed. Keep this window open and ask Codex for help.
  pause
  exit /b 1
)
echo.
echo Installation finished. Open a new Codex task to use the updated Skill.
pause
