@echo off
CLS 
TITLE Hostednetwork Easy Setup
ECHO =============================
ECHO ----------Welcome------------
ECHO =============================
ECHO This script will help you configuring hostednetwork easily.
ECHO Especially made for those in need of wireless network sharing via laptops/PCs.
ECHO -----------------------------------------
ECHO Press any key when you are ready to go...
pause > nul
goto check_os_version
:check_os_version
	goto check_win_10
:check_win_10
	ver | find /n /i "10" > nul
	if %errorlevel% equ 0 (
		goto checkPrivileges
	) else (
		goto check_win_81
		)
:check_win_81
	ver | find /n /i "6.3" > nul
	if %errorlevel% equ 0 (
		goto checkPrivileges
	) else (
		goto check_win_8
		)
:check_win_8
	ver | find /n /i "6.2" > nul
	if %errorlevel% equ 0 (
		goto checkPrivileges
	) else (
		goto check_win_7
		)
:check_win_7
	ver | find /n /i "6.1" > nul
	if %errorlevel% equ 0 (
		goto checkPrivileges
	) else (
		goto not_supported_os
		)
		
:not_supported_os
	cls
	title "ERROR DETECTED! :("
	echo ------------------------------------------------------------------
	echo Sorry, your operating system is not supported to run hostednetwork.
	echo Please upgrade to newer version of Windows to enable hostednetwork.
	echo ------------------------------------------------------------------
	echo Press any key to exit...
	pause > nul
	exit /B

:checkPrivileges 
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 

:getPrivileges 
if '%1'=='ELEV' (shift & goto gotPrivileges)  
ECHO. 
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation 
ECHO **************************************

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
"%temp%\OEgetPrivileges.vbs" 
exit /B 

:gotPrivileges 
::::::::::::::::::::::::::::
:START
::::::::::::::::::::::::::::
setlocal & pushd .

REM Run shell as admin (example) - put here code as you like
:runscript
	cls
	TITLE Hostednetwork Easy Setup
	ECHO What do you want to do?
	ECHO 1. Check hostednetwork support on your wireless adapter
	ECHO 2. Setup hostednetwork name (SSID) and passphrase
	ECHO 3. View hostednetwork SSID and passphrase
	ECHO 4. Start hostednetwork
	ECHO 5. Stop hostednetwork
	ECHO 6. View hostednetwork status
	ECHO 7. Exit this batch
	
	CHOICE /C:1234567 /M "Make your selection by typing the number of your choice."
	IF %errorlevel% equ 7 GOTO exitbatch
	IF %errorlevel% equ 6 GOTO connectionstat
	IF %errorlevel% equ 5 GOTO stophostednetwork
	IF %errorlevel% equ 4 GOTO starthostednetwork
	IF %errorlevel% equ 3 GOTO viewsssidkey
	IF %errorlevel% equ 2 GOTO setuphostednetwork
	IF %errorlevel% equ 1 GOTO checkhostednetwork

:checkhostednetwork
	cls
	echo Detecting hostednetwork support on your wireless drivers.
	echo Please wait...
	echo ==========================================================
	timeout 2 > nul
	set search_string=Hosted network supported  : Yes
	netsh wlan show drivers | find /i "%search_string%" > nul
	if %errorlevel% == 0 (
		title Hostednetwork supported
		echo ---------------------------------------------------------
		timeout 1 > nul
		echo Congratulations, your wifi adapter supports hostednetwork.
		echo You can create wireless infrastructure on it.
		echo ---------------------------------------------------------
		timeout 1 > nul
		echo Press any key to return to main menu
		pause > nul
		cls
		goto runscript
		) else (
		title Hostednetwork not supported
		echo ---------------------------------------------------------
		timeout 1 > nul
		echo Sorry, your wifi adapter doesn't support hostednetwork.
		echo Upgrade your wifi driver with latest version available.
		echo If your problem persists after upgrading, 
		echo contact your wifi manufacturer for support.
		echo ---------------------------------------------------------
		timeout 1 > nul
		echo Press any key to return to main menu
		pause > nul
		cls
		goto runscript
		)

:setuphostednetwork
goto setssid

	:setssid
	cls
	ECHO Configuring wireless SSID and passphrase
	ECHO =========================================
	timeout 1 > nul
	set /p ssid=Type the name of your wireless SSID to create:
	if defined ssid (
		ECHO Your SSID is %ssid%
		ECHO ===================
		timeout 1 > nul
		goto setkey
	) else (
		ECHO Error. You must specify an SSID for your hostednetwork.
		ECHO Press any key to retype SSID
		pause > nul
		goto setssid
		)
	:setkey
	set /p key=Type the key to use on created network (8 characters or more):
	if defined key (
		ECHO Your passphrase key is %key%
		ECHO ===============================
		timeout 1 > nul
		goto configwlan
	) else (
		ECHO Error. You must specify a passphrase key for your hostednetwork.
		ECHO Press any key to retype passphrase
		pause > nul
		goto setkey
		)
		
	:configwlan
	ECHO Please wait while configuring SSID and passphrase
	ECHO ==================================================
	timeout 2 > nul
	netsh wlan set hostednetwork mode=allow key=%key% keyusage=persistent ssid=%ssid% > nul
	if %errorlevel% equ 0 (
		ECHO Your hostednetwork has been configured
		ECHO Press any key to return
	) else (
		ECHO Failure occured when configuring hostednetwork
		ECHO Press any key to return
		)
	pause > nul
	cls
	goto runscript

:viewsssidkey
	cls
	ECHO Please wait while gathering information...
	ECHO ==========================================
	timeout 2 > nul
	if defined key (
	ECHO Here is your hostednetwork details
	ECHO ----------------------------------
	ECHO Wireless Network Name : %ssid% 
	ECHO Password              : %key%
	ECHO ----------------------------------
	timeout 2 > nul
	ECHO Press any key to return...
	pause > nul
	cls
	goto runscript
	) else (
		ECHO ---------------------------------------
		ECHO You didn't specify SSID and passphrase.
		ECHO ---------------------------------------
		timeout 2 > nul
		ECHO Press any key to return...
		pause > nul
		goto runscript
	)	
	
:starthostednetwork
	cls
	ECHO Starting hostednetwork. Please be patient...
	ECHO ============================================
	timeout 2 > nul
	goto checksupport
	
	:checksupport
	set search_string=Hosted network supported  : Yes
	netsh wlan show drivers | find /i "%search_string%" > nul
	if %errorlevel% equ 0 (
	goto checkavailability
	) else (
		ECHO The hostednetwork can't start.
		ECHO Make sure your wireless adapter supports hostednetwork.
		ECHO If problem persists, contact your wifi adapter manufacturer for support.
		ECHO Press any key to return...
		pause > nul
		cls
		goto runscript
	)
	
	:checkavailability
	set absentstring=Not available
	netsh wlan show hostednetwork | find "%absentstring%" > nul
	if %errorlevel% equ 1 (
	goto definedkey
	) else (
	ECHO Hostednetwork is unavailable
	ECHO -----------------------------------------------
	ECHO Make sure that wireless adapter is switched on.
	ECHO -----------------------------------------------
	timeout 2 > nul
	ECHO Press any key to return
	pause > nul
	goto runscript
	)
	
	:definedkey
		if defined key (
			goto starting_up
		
		) else (
			ECHO You didn't specify SSID and passphrase.
			ECHO Press any key to return to selection
			pause > nul
			cls
			goto runscript
		)
	
	:starting_up
			ECHO Please wait while checking hostednetwork status...
			=======================================================
			timeout 2 > nul
			set startedstatus=Not started
			netsh wlan show hostednetwork | find "%startedstatus%" > nul
			if %errorlevel% equ 0 (
				ECHO Starting up...
				ECHO --------------------------------------------
				timeout 1 > nul
				netsh wlan start hostednetwork > nul
				timeout 1 > nul
				ECHO The hostednetwork is started successfully
				ECHO --------------------------------------------
				ECHO Press any key to return...
				pause > nul
				cls
				goto runscript
			) else (
				timeout 1 > nul
				ECHO ------------------------------
				ECHO The hostednetwork is running.
				ECHO ------------------------------
				ECHO Press any key to return...
				pause > nul
				cls
				goto runscript
			)

:stophostednetwork
	cls
	ECHO Stopping hostednetwork. Please wait...
	ECHO ======================================
	timeout 2 > nul
	set startedstatus=Status                 : Started
	netsh wlan show hostednetwork | find /i "%startedstatus%" > nul
	if %errorlevel% equ 0 (
		netsh wlan stop hostednetwork > nul
		ECHO -----------------------------------------
		timeout 1 > nul
		ECHO The hostednetwork is stopped successfully
		ECHO -----------------------------------------
		timeout 1 > nul
		ECHO Press any key to return...
		pause > nul
		cls
		goto runscript
	) else (
		ECHO -----------------------------------------
		timeout 1 > nul
		ECHO The hostednetwork is not running.
		ECHO -----------------------------------------
		timeout 1 > nul
		ECHO Press any key to return...
		pause > nul
		cls
		goto runscript
	)

:connectionstat
	cls
	ECHO Please wait while gathering stats...
	ECHO =====================================
	timeout 1 > nul
	netsh wlan show hostednetwork
	timeout 1 > nul
	ECHO =====================================
	ECHO Press any key to return...
	pause > nul
	goto runscript
	
	
:exitbatch
	cls
	echo Are you sure?
	timeout 1 > nul
	echo -----------------------------------
	echo Press Y to exit, otherwise press N.
	timeout 1 > nul
	echo -----------------------------------
	choice /c YN
	if %errorlevel% equ 2 (
		cls
		goto runscript
		)
	if %errorlevel% equ 1 exit /B
