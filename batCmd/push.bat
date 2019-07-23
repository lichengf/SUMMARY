

@echo off
cd /d %~dp0
set paths=%0
cd %paths%
::echo %cd%
::pause
for /f "delims=" %%i in ('dir .\ /b /s /a-d ^|findstr /i ".so"') do (
	echo  %cd%\%%~ni.so
	adb push %cd%\%%~ni.so /system/app
	)
pause
