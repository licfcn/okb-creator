@echo off
attrib -R /S /D "%~dp0raw\*.*"
attrib -R "%~dp0raw"
echo raw/ 已解锁，添加完文件后运行 lock-raw.bat
pause
