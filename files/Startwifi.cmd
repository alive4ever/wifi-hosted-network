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
ECHO to turn on internet sharing,
ECHO simply choose the network adapter with internet access.
ECHO right click on it, properties, sharing,
ECHO mark allow others to connect
ECHO home networking connection is
ECHO "Local area connection 11" (win8) or
ECHO "Wireless network connection 2" (win7)
ECHO -------------------------------------
timeout 1 > nul
ECHO starting wireless network sharing
timeout 1 > nul
ECHO =====================================
timeout 2 > nul
netsh wlan start hostednetwork
pause