@echo off
attrib +R /S /D "%~dp0raw\*.*"
attrib +R "%~dp0raw"
echo raw/ 已锁定为只读
pause
