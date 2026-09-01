@echo off
setlocal
cd /d "%~dp0"
title CodexBridge 微信桥接服务
echo 正在启动 CodexBridge 微信桥接服务...
echo 项目目录：%CD%
echo 关闭此窗口将停止服务。
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir = Join-Path $env:USERPROFILE '.codexbridge\weixin\accounts'; $accounts = @(Get-ChildItem -LiteralPath $dir -Filter '*.json' -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '\.(context-tokens|sync)\.json$' }); if ($accounts.Count -eq 0) { exit 1 }"
if errorlevel 1 (
  echo 未检测到微信登录状态，正在打开二维码登录...
  echo.
  call npm run weixin:login -- --timeout-sec 480
  if errorlevel 1 (
    echo.
    echo 微信扫码登录失败或超时，服务未启动。
    pause
    exit /b 1
  )
  echo.
  echo 登录成功，正在启动微信桥接服务...
)

call npm run weixin:serve
echo.
echo CodexBridge 微信桥接服务已停止。
pause
