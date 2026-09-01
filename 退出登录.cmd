@echo off
setlocal
cd /d "%~dp0"
title 退出 CodexBridge 微信账号

echo 正在停止当前微信桥接服务...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$root = [IO.Path]::GetFullPath((Get-Location).Path); $items = @(Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -and $_.CommandLine -match 'src[\\/]+cli\.ts[ ]+weixin[ ]+serve' -and $_.CommandLine -like ('*' + $root + '*') }); foreach ($item in $items) { taskkill.exe /PID $item.ProcessId /T /F *> $null }"
timeout /t 2 /nobreak >nul

echo 正在退出微信登录并删除本机凭据...
call npm run weixin:logout
if errorlevel 1 (
  echo.
  echo 退出登录失败。
  echo 如果存在多个账号，请手动执行：npm run weixin:logout -- --account-id 账号ID
  pause
  exit /b 1
)

echo.
echo 已退出微信登录。Codex 对话记录和项目文件未被删除。
pause
