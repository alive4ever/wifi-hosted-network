@echo off
TITLE Easy Wireless Sharing (Conectify Replacement)
:checkadminrights
net session >nul 2>&1
    if %errorLevel% == 0 (
        goto start_ssid
    ) else (
        echo You must start this script in administrator mode.
	echo Right click the script and choose "Run as administrator"
	echo Press any key to exit
	pause > nul
	exit /b
    )



:start_ssid
cls
ECHO Welcome
ECHO This is easy hotspot configuration

ECHO 1. Set wireless sharing name
ECHO 2. Set passphrase
ECHO 3. exit

CHOICE /c 123 /M "What do you want to do?"

if %errorlevel% equ 3 goto wlan_exit
if %errorlevel% equ 2 goto wlan_pass
if %errorlevel% equ 1 goto wlan_name

:wlan_name
cls
ECHO please input your desired wireless sharing name.
ECHO the name will be visible on wifi-enabled devices,
ECHO such as smartphones or laptops.
set /p ssid="Type it now : "
if defined ssid (
	goto ssid_set
	) else (goto wlan_name_error)

:ssid_set
ECHO Your SSID is %ssid%
netsh wlan set hostednetwork mode=allow ssid=%ssid% > nul
timeout 2 > nul
ECHO Your SSID successfully set. Press any key to continue.
pause > nul
goto start_ssid

:wlan_name_error
ECHO You didn't input anything.
ECHO Don't make me confused.
ECHO Press any key to go back.
pause > nul
goto wlan_name

:wlan_pass
cls
ECHO please input your desired wireless sharing password.
ECHO the the password will be used to connect.
ECHO ====================================================
set /p pass="Type it now : (8 characters or more) "
if defined pass (goto pass_set
	) else (goto wlan_pass_error)

:pass_set
ECHO Your password is %pass%
netsh wlan set hostednetwork mode=allow key=%pass% keyUsage=persistent > nul
timeout 2 > nul
ECHO Your password successfully set. Press any key to continue.
pause > nul
goto start_ssid

:wlan_pass_error
ECHO You didn't input anything.
ECHO Don't make me confused.
ECHO Press any key to go back.
pause > nul
goto wlan_pass


:wlan_exit
ECHO Are you sure?
timeout 2 > nul
choice /c YN

if %errorlevel% equ 2 goto start_ssid
if %errorlevel% equ 1 goto exit /b