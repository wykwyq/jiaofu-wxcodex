@echo off
setlocal
cd /d "%~dp0"
title 更换 CodexBridge 微信账号

echo 正在停止当前微信桥接服务...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$root = [IO.Path]::GetFullPath((Get-Location).Path); $items = @(Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and $_.CommandLine -match 'src[\\/]+cli\.ts[ ]+weixin[ ]+serve' -and $_.CommandLine -like ('*' + $root + '*') }); foreach ($item in $items) { taskkill.exe /PID $item.ProcessId /T /F *> $null }"
timeout /t 2 /nobreak >nul

echo 正在清除旧微信登录上下文...
call npm run weixin:clear-context
if errorlevel 1 (
  echo.
  echo 清除旧账号失败，未启动新的登录流程。
  echo 如果存在多个账号，请手动执行：npm run weixin:clear-context -- --account-id 账号ID
  pause
  exit /b 1
)

echo.
echo 正在启动新的微信扫码登录，请使用要更换的新账号扫码...
call npm run weixin:login -- --timeout-sec 480
if errorlevel 1 (
  echo.
  echo 新微信账号登录失败或超时，服务未启动。
  pause
  exit /b 1
)

echo.
echo 新账号登录成功，正在启动微信桥接服务...
call npm run weixin:serve

echo.
echo CodexBridge 微信桥接服务已停止。
pause
