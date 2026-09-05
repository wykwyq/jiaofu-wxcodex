@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\service\install-windows-task.ps1" -DefaultCwd "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\service\status-windows-task.ps1"
