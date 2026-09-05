@echo off
setlocal
cd /d "%~dp0"
title CodexBridge Weixin Bridge
echo Starting CodexBridge Weixin bridge...
echo Project directory: %CD%
echo Close this window to stop the foreground service.
echo.

if not defined CODEX_REAL_BIN for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\resolve-codex-bin.ps1"`) do if not defined CODEX_REAL_BIN set "CODEX_REAL_BIN=%%I"
if not defined CODEX_REAL_BIN (
  echo Codex CLI was not found on PATH.
  echo Install Codex CLI or set CODEX_REAL_BIN to the full path of codex.exe or codex.cmd.
  pause
  exit /b 1
)
echo Codex CLI: %CODEX_REAL_BIN%

powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir = Join-Path $env:USERPROFILE '.codexbridge\weixin\accounts'; $accounts = @(Get-ChildItem -LiteralPath $dir -Filter '*.json' -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '\.(context-tokens|sync)\.json$' }); if ($accounts.Count -eq 0) { exit 1 }"
if errorlevel 1 (
  echo No saved Weixin account found. Starting QR login...
  echo.
  call npm run weixin:login -- --timeout-sec 480
  if errorlevel 1 (
    echo.
    echo Weixin QR login failed or timed out.
    pause
    exit /b 1
  )
  echo.
  echo Login completed.
)

call npm run weixin:serve -- --cwd "%CD%"
echo.
echo CodexBridge Weixin bridge stopped.
pause
