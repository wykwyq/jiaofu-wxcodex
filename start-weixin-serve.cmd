@echo off
setlocal
cd /d "%~dp0"
title CodexBridge WeChat Service
echo Starting CodexBridge WeChat service...
echo Project: %CD%
echo Close this window to stop the service.
echo.
npm run weixin:serve
echo.
echo CodexBridge WeChat service stopped.
pause
