@echo off
setlocal
cd /d "%~dp0"
title CodexBridge Weixin Account Cleanup

echo Stopping CodexBridge service...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Stop-ScheduledTask -TaskName 'CodexBridge-Weixin' -ErrorAction SilentlyContinue; $root = [IO.Path]::GetFullPath((Get-Location).Path); $items = @(Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and $_.CommandLine -match 'src[\\/]+cli\.ts[ ]+weixin[ ]+serve' -and $_.CommandLine -like ('*' + $root + '*') }); foreach ($item in $items) { taskkill.exe /PID $item.ProcessId /T /F *> $null }"
timeout /t 2 /nobreak >nul

echo Clearing all saved Weixin accounts and local credentials...
call npm run weixin:clear-accounts
if errorlevel 1 (
  echo Account cleanup failed.
  pause
  exit /b 1
)

echo All saved Weixin accounts were cleared.
echo Run start-weixin-serve.cmd to scan a new login QR code.
pause
