@echo off
setlocal
cd /d "%~dp0"
title CodexBridge WeChat Service
echo Starting CodexBridge WeChat service...
echo Project: %CD%
echo Close this window to stop the service.
echo.
if not defined CODEX_REAL_BIN for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\resolve-codex-bin.ps1"`) do if not defined CODEX_REAL_BIN set "CODEX_REAL_BIN=%%I"
if not defined CODEX_REAL_BIN (
  echo Codex CLI was not found on PATH.
  echo Install Codex CLI or set CODEX_REAL_BIN to the full path of codex.exe or codex.cmd.
  pause
  exit /b 1
)
echo Codex CLI: %CODEX_REAL_BIN%
npm run weixin:serve
echo.
echo CodexBridge WeChat service stopped.
pause
