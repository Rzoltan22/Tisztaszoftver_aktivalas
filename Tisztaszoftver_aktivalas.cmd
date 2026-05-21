@echo off
color 07
mode con cols=85 lines=35
TITLE Tisztaszoftver KMS Aktivator

:: ESC karakter definialasa az ANSI szinekhez
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "RESET=%ESC%[0m"

:: Rendszergazdai jogok ellenorzese
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if not errorlevel 1 goto gotAdmin

echo Rendszergazdai jogosultsag kerese...
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

:MainMenu
cls
echo %GREEN%=================================================================================%RESET%
echo %GREEN%                        TISZTASZOFTVER KMS AKTIVALO                          %RESET%
echo %GREEN%                            Szerver: kms.edu.hu                              %RESET%
echo %GREEN%=================================================================================%RESET%
echo.
echo     Windows aktivalas:
echo     [1] Windows 10/11 Pro
echo     [2] Windows 10/11 Enterprise
echo     [3] Windows Server 2016 Standard
echo     [4] Windows Server 2019 Standard
echo     [5] Windows Server 2022 Standard
echo.
echo     Office aktivalas:
echo     [6] Office 2016 (64-bit / 32-bit)
echo     [7] Office 2019 (64-bit / 32-bit)
echo     [8] Office 2021 (64-bit / 32-bit)
echo.
echo =================================================================================
echo     [0] Kilepes
echo.
set "choice="
set /p choice="Valassz egy menupontot a billentyuzet segitsegevel [0-8]: "

if "%choice%"=="1" (
    set "GVLK=W269N-WFGWX-YVC9B-4J6C9-T83GX"
    set "EXPECTED_SERVER=0"
    set "EXPECTED_SERVER_YEAR="
    goto WinActivate
)
if "%choice%"=="2" (
    set "GVLK=NPPR9-FWDCX-D2C8J-H872K-2YT43"
    set "EXPECTED_SERVER=0"
    set "EXPECTED_SERVER_YEAR="
    goto WinActivate
)
if "%choice%"=="3" (
    set "GVLK=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"
    set "EXPECTED_SERVER=1"
    set "EXPECTED_SERVER_YEAR=2016"
    goto WinActivate
)
if "%choice%"=="4" (
    set "GVLK=N69G4-B89J2-4G8F4-WWYCC-J464C"
    set "EXPECTED_SERVER=1"
    set "EXPECTED_SERVER_YEAR=2019"
    goto WinActivate
)
if "%choice%"=="5" (
    set "GVLK=VDYBN-27WPP-V4HQT-9VMD4-VMK7H"
    set "EXPECTED_SERVER=1"
    set "EXPECTED_SERVER_YEAR=2022"
    goto WinActivate
)
if "%choice%"=="6" (
    set "O_GVLK=XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99"
    goto OfficeActivate
)
if "%choice%"=="7" (
    set "O_GVLK=NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP"
    goto OfficeActivate
)
if "%choice%"=="8" (
    set "O_GVLK=FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH"
    goto OfficeActivate
)
if "%choice%"=="0" exit

:: Helytelen opcio kezelese
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Helytelen opciot valasztottal! Kerlek valassz a listabol [0-8].           %RESET%
echo %RED%=================================================================================%RESET%
echo.
pause
goto MainMenu


:: =================================================================================
:: HALOZAT ELLENORZES FUGGVENY
:: =================================================================================
:CheckNetwork
echo.
echo Halozat IP cimenek ellenorzese...
set "PUB_IP="

powershell -NoProfile -ExecutionPolicy Bypass -Command "(Invoke-RestMethod -Uri 'https://api.ipify.org' -UseBasicParsing -TimeoutSec 5).Trim()" > "%temp%\pub_ip.txt" 2>nul

if not exist "%temp%\pub_ip.txt" goto SkipIP
set /p PUB_IP=<"%temp%\pub_ip.txt"
del "%temp%\pub_ip.txt" >nul 2>&1
:SkipIP

if "%PUB_IP%"=="" goto IPError

echo Publikus IP cim: %PUB_IP%
echo %PUB_IP% | findstr /b "195.199." >nul
if not errorlevel 1 goto IPRight

goto IPWrong

:IPRight
echo %GREEN%A halozat megfelelo (195.199.x.x tartomany). Folytatas...%RESET%
echo.
exit /b 0

:IPError
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Nem sikerult lekerdezni a publikus IP cimet!                               %RESET%
echo %RED%Ellenorizd az internetkapcsolatot (vagy a tuzfal blokkolja a lekerezest).        %RESET%
echo %RED%=================================================================================%RESET%
echo.
pause
exit /b 1

:IPWrong
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Nem megfelelo halozat!                                            %RESET%
echo %RED%A jelenlegi publikus IP cim (%PUB_IP%) nincs a 195.199.0.0/16 tartomanyban.      %RESET%
echo %RED%Az aktivalas kizarolag a magyar kozoktatasi halozatbol (NIIF) mukodik!           %RESET%
echo %RED%=================================================================================%RESET%
echo.
pause
exit /b 1
:: =================================================================================


:WinActivate
cls
echo %GREEN%=================================================================================%RESET%
echo %GREEN%Windows KMS Aktivalas folyamatban...                                         %RESET%
echo %GREEN%=================================================================================%RESET%

:: --- IP ELLENORZES MEGHIVASA ---
call :CheckNetwork
if errorlevel 1 goto MainMenu

:: --- WINDOWS VERZIO ELLENORZESE ---
echo Windows verzio ellenorzese a regisztracios adatbazisbol...
set "CURRENT_OS=Ismeretlen"
for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do set "CURRENT_OS=%%B"

echo %CURRENT_OS% | find /i "Server" >nul
if not errorlevel 1 (
    set "IS_SERVER=1"
) else (
    set "IS_SERVER=0"
)

REM 1. Ellenorzes: Asztali vs Szerver elteres
if "%EXPECTED_SERVER%"=="0" if "%IS_SERVER%"=="1" goto WinMismatchServer
if "%EXPECTED_SERVER%"=="1" if "%IS_SERVER%"=="0" goto WinMismatchClient

REM 2. Ellenorzes: Server evszam elteres
if "%EXPECTED_SERVER%"=="1" (
    echo %CURRENT_OS% | find /i "%EXPECTED_SERVER_YEAR%" >nul
    if errorlevel 1 goto WinMismatchServerYear
)
goto MismatchCheckDone

:WinMismatchServer
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Rendszer tipus elteres!                                           %RESET%
echo %RED%A menuben asztali Windows-t valasztottal, de a gepen Windows Server fut!         %RESET%
echo %RED%Telepitett rendszer: %CURRENT_OS%
echo %RED%Kerlek, a megfelelo Windows Server (3-5) opciot valaszd a menubol!               %RESET%
echo %RED%=================================================================================%RESET%
echo.
pause
goto MainMenu

:WinMismatchClient
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Rendszer tipus elteres!                                           %RESET%
echo %RED%A menuben Windows Server-t valasztottal, de a gepen asztali Windows fut!         %RESET%
echo %RED%Telepitett rendszer: %CURRENT_OS%
echo %RED%Kerlek, a megfelelo Windows 10/11 (1-2) opciot valaszd a menubol!                %RESET%
echo %RED%=================================================================================%RESET%
echo.
pause
goto MainMenu

:WinMismatchServerYear
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Windows Server verzio elteres!                                    %RESET%
echo %RED%A menuben Server %EXPECTED_SERVER_YEAR%-t valasztottal, de a gepen masik verzio fut!%RESET%
echo %RED%Telepitett rendszer: %CURRENT_OS%
echo %RED%Kerlek, a megfelelo Windows Server opciot valaszd a menubol!                     %RESET%
echo %RED%=================================================================================%RESET%
echo.
pause
goto MainMenu

:MismatchCheckDone
echo %GREEN%Rendszer kompatibilis (%CURRENT_OS%).%RESET%
echo.

echo Regi licenckulcs eltavolitasa es registry tisztitasa...
cscript C:\Windows\System32\slmgr.vbs /upk //nologo >nul 2>&1
cscript C:\Windows\System32\slmgr.vbs /cpky //nologo >nul 2>&1

echo Uj kulcs telepitese (%GVLK%)...
cscript C:\Windows\System32\slmgr.vbs /ipk %GVLK% //nologo

echo Szerver beallitasa: kms.edu.hu...
cscript C:\Windows\System32\slmgr.vbs /skms kms.edu.hu //nologo

:RetryWinAct
echo.
echo --------------------------------------------------------
echo Aktivacios kiserlet folyamatban (Windows)...
echo --------------------------------------------------------
cscript C:\Windows\System32\slmgr.vbs /ato //nologo > "%temp%\kms_win_log.txt"
type "%temp%\kms_win_log.txt"

find /i "Hiba:" "%temp%\kms_win_log.txt" >nul
if not errorlevel 1 goto FailWin
find /i "Error:" "%temp%\kms_win_log.txt" >nul
if not errorlevel 1 goto FailWin

find /i "success" "%temp%\kms_win_log.txt" >nul
if not errorlevel 1 goto SuccessWin
find /i "siker" "%temp%\kms_win_log.txt" >nul
if not errorlevel 1 goto SuccessWin

goto FailWin

:SuccessWin
echo.
echo %GREEN%=================================================================================%RESET%
echo %GREEN%SIKERES AKTIVALAS! A folyamat befejezodott.                                     %RESET%
echo %GREEN%=================================================================================%RESET%
del "%temp%\kms_win_log.txt" >nul 2>&1
echo.
pause
goto MainMenu

:FailWin
echo.
echo %RED%A szerver nem valaszol, vagy tulterhelt. Ujraprobalkozas 5 masodperc mulva...%RESET%
del "%temp%\kms_win_log.txt" >nul 2>&1
timeout /t 5
goto RetryWinAct


:OfficeActivate
cls
echo %GREEN%=================================================================================%RESET%
echo %GREEN%Office KMS Aktivalas folyamatban...                                            %RESET%
echo %GREEN%=================================================================================%RESET%
echo.

:: --- IP ELLENORZES MEGHIVASA ---
call :CheckNetwork
if errorlevel 1 goto MainMenu

:: Automatikus, biztonsagos OSPP.VBS kereso
set "OSPP_PATH="
set "P1=C:\Program Files\Microsoft Office\Office16\ospp.vbs"
set "P2=C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs"
set "P3=C:\Program Files\Microsoft Office\root\Office16\ospp.vbs"
set "P4=C:\Program Files (x86)\Microsoft Office\root\Office16\ospp.vbs"

if exist "%P1%" set "OSPP_PATH=%P1%"
if exist "%P2%" set "OSPP_PATH=%P2%"
if exist "%P3%" set "OSPP_PATH=%P3%"
if exist "%P4%" set "OSPP_PATH=%P4%"

if not defined OSPP_PATH goto OfficeNotFound
goto OfficeFound

:OfficeNotFound
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Az ospp.vbs fajl nem talalhato a szamitogepen!                             %RESET%
echo %RED%Biztosan telepitve van a Microsoft Office 2016/2019/2021?                        %RESET%
echo %RED%=================================================================================%RESET%
echo.
pause
goto MainMenu

:OfficeFound
echo Megtalalt Office utvonal: "%OSPP_PATH%"
echo Uj kulcs telepitese (%O_GVLK%)...
cscript //nologo "%OSPP_PATH%" /inpkey:%O_GVLK% > "%temp%\kms_off_inpkey_log.txt"
type "%temp%\kms_off_inpkey_log.txt"

REM -- Verzio ellenorzes: Sikerult a kulcsot elfogadnia a rendszernek? --
find /i "0xC004F069" "%temp%\kms_off_inpkey_log.txt" >nul
if not errorlevel 1 goto WrongOfficeVersion
find /i "Error" "%temp%\kms_off_inpkey_log.txt" >nul
if not errorlevel 1 goto WrongOfficeVersion
find /i "Hiba" "%temp%\kms_off_inpkey_log.txt" >nul
if not errorlevel 1 goto WrongOfficeVersion

del "%temp%\kms_off_inpkey_log.txt" >nul 2>&1
goto ContinueOfficeAct

:WrongOfficeVersion
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: A termekkulcsot nem fogadta el a rendszer (SKU not found)!       %RESET%
echo %RED%Valoszinuleg NEM ezt az Office verziot telepitetted a gepre, vagy masik kiadas. %RESET%
echo %RED%Kerlek, ellenorizd a gepen levo Office verziojat, es probald ujra a helyes menuponttal.%RESET%
echo %RED%=================================================================================%RESET%
del "%temp%\kms_off_inpkey_log.txt" >nul 2>&1
echo.
pause
goto MainMenu

:ContinueOfficeAct
echo Szerver beallitasa: kms.edu.hu...
cscript //nologo "%OSPP_PATH%" /sethst:kms.edu.hu

echo Port beallitasa: 1688...
cscript //nologo "%OSPP_PATH%" /setprt:1688

:RetryOfficeAct
echo.
echo --------------------------------------------------------
echo Aktivacios kiserlet folyamatban (Office)...
echo --------------------------------------------------------
cscript //nologo "%OSPP_PATH%" /act > "%temp%\kms_off_log.txt"
type "%temp%\kms_off_log.txt"

find /i "Hiba:" "%temp%\kms_off_log.txt" >nul
if not errorlevel 1 goto FailOffice
find /i "Error:" "%temp%\kms_off_log.txt" >nul
if not errorlevel 1 goto FailOffice
find /i "0xC004F074" "%temp%\kms_off_log.txt" >nul
if not errorlevel 1 goto FailOffice

find /i "success" "%temp%\kms_off_log.txt" >nul
if not errorlevel 1 goto SuccessOffice
find /i "siker" "%temp%\kms_off_log.txt" >nul
if not errorlevel 1 goto SuccessOffice

goto FailOffice

:SuccessOffice
echo.
echo %GREEN%=================================================================================%RESET%
echo %GREEN%SIKERES AKTIVALAS! A folyamat befejezodott.                                     %RESET%
echo %GREEN%=================================================================================%RESET%
del "%temp%\kms_off_log.txt" >nul 2>&1
echo.
pause
goto MainMenu

:FailOffice
echo.
echo %RED%A szerver nem valaszol, vagy tulterhelt. Ujraprobalkozas 5 masodperc mulva...%RESET%
del "%temp%\kms_off_log.txt" >nul 2>&1
timeout /t 5
goto RetryOfficeAct