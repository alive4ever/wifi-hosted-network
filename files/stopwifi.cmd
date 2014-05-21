@echo off
:checkadminrights
net session >nul 2>&1
    if %errorLevel% == 0 (
        goto startit
    ) else (
        echo You must start this script in administrator mode.
	echo Right click the script and choose "Run as administrator"
	echo Press any key to exit
	pause > nul
	exit /b
    )
:startit
echo Stopping wireless sharing on your computer
timeout 1 > nul
echo ===========================================
timeout 1 > nul
netsh wlan stop hostednetwork
pause