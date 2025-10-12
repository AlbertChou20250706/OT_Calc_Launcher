@echo off
REM ============================================================
REM  Script Name : Run_OT_Calculator.bat
REM  Purpose     : Launch OT_Calculator.html via OT_Calc_Launcher.ps1
REM  Version     : v1.3.0
REM  Usage       : Double-click (default zh)
REM                Or: Run_OT_Calculator.bat en   /   Run_OT_Calculator.bat ja
REM ============================================================

setlocal ENABLEDELAYEDEXPANSION
set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%OT_Calc_Launcher.ps1"
set "HTML=%SCRIPT_DIR%OT_Calculator.html"

set "LANG=zh"
if not "%~1"=="" set "LANG=%~1"

REM Prefer PowerShell Core (pwsh), then Windows PowerShell
where pwsh >nul 2>&1 && (set "PSCMD=pwsh -NoLogo -NoProfile") || (set "PSCMD=powershell -NoLogo -NoProfile")

if not exist "%PS1%" (
  echo [WARN] Launcher not found: "%PS1%"
  if exist "%HTML%" (
    echo [INFO] Opening HTML directly...
    start "" "%HTML%"
  ) else (
    echo [FAIL] Neither launcher nor HTML found in "%SCRIPT_DIR%"
  )
  echo.
  pause
  goto :end
)

echo [INFO] Launching PowerShell launcher (Lang=%LANG%)...
%PSCMD% -ExecutionPolicy Bypass -File "%PS1%" -Lang %LANG%
set "ERR=%ERRORLEVEL%"

if not "%ERR%"=="0" (
  echo.
  echo [WARN] PowerShell returned code %ERR%.
  echo If you saw "running scripts is disabled", enable it for CurrentUser:
  echo     1) Right-click Start ^> Windows PowerShell ^(Admin^) or Terminal ^(Admin^)
  echo     2) Paste:  powershell -NoLogo -NoProfile -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned"
  echo     3) Then run this .bat again.
  echo If 'pwsh' not found, install PowerShell 7:  winget install --id Microsoft.PowerShell -e
  echo.
  pause
)

:end
endlocal
