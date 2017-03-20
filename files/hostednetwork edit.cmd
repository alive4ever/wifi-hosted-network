@echo off
TITLE Windows 7/8/8.1/10 hostednetwork easy-setup
COLOR 17
ECHO Welcome to Windows 7/8/8.1/10 Hostednetwork easy configuration
ECHO You must run this script in administrator mode.
ECHO Press any key to check for administrative permissions.
pause > nul
goto check_Permissions

:check_Permissions
	net session >nul 2>&1
	IF %ERRORLEVEL% EQU 0 (
		cls
		echo Success: Administrative permissions confirmed.
		goto runscript
	) ELSE (
		cls
		goto stopscript
	)

:runscript
	ECHO What do you want to do?
	ECHO 1. Setup hostednetwork name (SSID) and passphrase
	ECHO 2. View hostednetwork SSID and passphrase
	ECHO 3. Start hostednetwork
	ECHO 4. Stop hostednetwork
	ECHO 5. Exit this batch
	
	CHOICE /C:12345 /M "Make your selection by typing the number of your choice."
	IF ERRORLEVEL 5 GOTO Label5
	IF ERRORLEVEL 4 GOTO Label4
	IF ERRORLEVEL 3 GOTO Label3
	IF ERRORLEVEL 2 GOTO Label2
	IF ERRORLEVEL 1 GOTO Label1

:label1
	:setssid
	cls
	set /p ssid=Type the name of your wireless SSID to create:
	if defined ssid (
		ECHO Your SSID is %ssid%
		ECHO Press any key to go to next step
		pause > nul
		goto setkey
	) else (
		ECHO Error. You must specify an SSID for your hostednetwork.
		ECHO Press any key to retype SSID
		pause > nul
		goto setssid
		)
	:setkey
	cls
	set /p key=Type the key to use on created network (8 characters or more):
	if defined key (
		ECHO Your passphrase key is %key%
		ECHO Press any key to go to next step
		pause > nul
		goto configwlan
	) else (
		ECHO Error. You must specify a passphrase key for your hostednetwork.
		ECHO Press any key to retype passphrase
		pause > nul
		goto setkey
		)
		
	:configwlan
	cls
	ECHO Please wait
	netsh wlan set hostednetwork mode=allow key=%key% keyusage=persistent ssid=%ssid% > nul
	if errorlevel 0 (
		ECHO Your hostednetwork has been configured
	) else (
		ECHO Failure configuring hostednetwork
		)
	pause
	cls
	goto runscript

:label2
	cls
	if defined key (
	ECHO Here is your hostednetwork details
	ECHO Wireless Network Name: %ssid% 
	ECHO Password: %key%
	pause
	cls
	goto runscript
	) else (
		cls
		ECHO You don't specify SSID and passphrase.
		ECHO Press any key to configure SSID and passphrase
		pause > nul
		goto label1
	)	
	
:label3
	cls
	ECHO Starting hostednetwork. Please wait
	netsh wlan start hostednetwork > nul
	ECHO Your hostednetwork is ready. 
	pause
	cls
	goto runscript

:label4
	cls
	
	ECHO Stopping hostednetwork. Please wait
	netsh wlan stop hostednetwork > nul
	ECHO The hostednetwork is stopped
	pause
	cls
	goto runscript
	
:label5
	cls
	echo Press Y to exit, otherwise press N.
	choice /c YN
	if errorlevel 2 (
		cls
		goto runscript
		)
	if errorlevel 1 exit

:stopscript
	echo Failure: Not enough privilege to perform the operation
	echo Restart this script in administrator mode.
	ECHO If you have UAC enabled, right click this script file
	ECHO and choose Run as administrator
	ECHO Press any key to exit...
	pause > nul
	exit
	
