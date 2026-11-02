@echo off
chcp 65001 >nul
setlocal
title Palette Studio インストーラーの取得
set "BASE=https://raw.githubusercontent.com/phkdow/palette-studio-updates/main/setup"
set "VER=0.3.0"
set "WORK=%TEMP%\PaletteStudioSetup"
if exist "%WORK%" rd /s /q "%WORK%"
mkdir "%WORK%"
echo Palette Studio %VER% のインストーラーをダウンロードします（約116MB）...
for /l %%i in (0,1,6) do (
  call :get %%i
  if errorlevel 1 goto :fail
)
copy /b "%WORK%\PaletteStudio-Setup-%VER%.part*" "%WORK%\PaletteStudio-Setup-%VER%.exe" >nul
for /f %%h in ('powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 '%WORK%\PaletteStudio-Setup-%VER%.exe').Hash.ToLower()"') do set "HASH=%%h"
if /i not "%HASH%"=="8e12cf434944e81d8d05cd2d7569c29442f7a5a8b67c375e52b451c37d848691" (
  echo 受け取ったファイルが壊れています。もう一度実行してください。
  goto :fail
)
echo ダウンロードできました。インストーラーを起動します。Palette Studio が開いている場合は先に閉じてください。
start "" "%WORK%\PaletteStudio-Setup-%VER%.exe"
exit /b 0
:get
set "N=%1"
if %1 LSS 10 set "N=0%1"
echo   部品 %N% ...
powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing -Uri '%BASE%/PaletteStudio-Setup-%VER%.part%N%' -OutFile '%WORK%\PaletteStudio-Setup-%VER%.part%N%' } catch { exit 1 }"
exit /b %errorlevel%
:fail
echo ダウンロードに失敗しました。インターネットにつながっているか確かめて、もう一度実行してください。
pause
exit /b 1
