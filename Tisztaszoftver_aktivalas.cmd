@echo off
color 07
mode con cols=85 lines=35
TITLE Tisztaszoftver KMS Aktivator

:: ESC karakter definialasa az ANSI szinekhez (nativ CMD megoldas)
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "RESET=%ESC%[0m"

:: Rendszergazdai jogok ellenorzese
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Rendszergazdai jogosultsag kerese...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
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
echo     [6] Office 2016 (64-bit)
echo     [7] Office 2016 (32-bit / x86)
echo     [8] Office 2019 (64-bit)
echo     [9] Office 2019 (32-bit / x86)
echo     [10] Office 2021 (64-bit)
echo     [11] Office 2021 (32-bit / x86)
echo.
echo =================================================================================
echo     [0] Kilepes
echo.
set "choice="
set /p choice="Valassz egy menupontot a billentyuzet segitsegevel [0-11]: "

if "%choice%"=="1" (
    set "GVLK=W269N-WFGWX-YVC9B-4J6C9-T83GX"
    goto WinActivate
)
if "%choice%"=="2" (
    set "GVLK=NPPR9-FWDCX-D2C8J-H872K-2YT43"
    goto WinActivate
)
if "%choice%"=="3" (
    set "GVLK=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"
    goto WinActivate
)
if "%choice%"=="4" (
    set "GVLK=N69G4-B89J2-4G8F4-WWYCC-J464C"
    goto WinActivate
)
if "%choice%"=="5" (
    set "GVLK=VDYBN-27WPP-V4HQT-9VMD4-VMK7H"
    goto WinActivate
)
if "%choice%"=="6" (
    set "OSPP_PATH=C:\Program Files\Microsoft Office\Office16\ospp.vbs"
    set "O_GVLK=XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99"
    goto OfficeActivate
)
if "%choice%"=="7" (
    set "OSPP_PATH=C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs"
    set "O_GVLK=XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99"
    goto OfficeActivate
)
if "%choice%"=="8" (
    set "OSPP_PATH=C:\Program Files\Microsoft Office\Office16\ospp.vbs"
    set "O_GVLK=NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP"
    goto OfficeActivate
)
if "%choice%"=="9" (
    set "OSPP_PATH=C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs"
    set "O_GVLK=NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP"
    goto OfficeActivate
)
if "%choice%"=="10" (
    set "OSPP_PATH=C:\Program Files\Microsoft Office\Office16\ospp.vbs"
    set "O_GVLK=FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH"
    goto OfficeActivate
)
if "%choice%"=="11" (
    set "OSPP_PATH=C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs"
    set "O_GVLK=FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH"
    goto OfficeActivate
)
if "%choice%"=="0" exit

:: Helytelen opcio kezelese (Szelektiven Piros szoveg)
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: Helytelen opciot valasztottal! Kerlek valassz a listabol [0-11].          %RESET%
echo %RED%=================================================================================%RESET%
echo.
echo Nyomj meg egy gombot az ujraprobalkozashoz...
pause >nul
goto MainMenu

:WinActivate
cls
echo %GREEN%=================================================================================%RESET%
echo %GREEN%Windows KMS Aktivalas folyamatban...                                         %RESET%
echo %GREEN%=================================================================================%RESET%
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
if %errorlevel% equ 0 goto FailWin
find /i "Error:" "%temp%\kms_win_log.txt" >nul
if %errorlevel% equ 0 goto FailWin

find /i "success" "%temp%\kms_win_log.txt" >nul
if %errorlevel% equ 0 goto SuccessWin
find /i "siker" "%temp%\kms_win_log.txt" >nul
if %errorlevel% equ 0 goto SuccessWin

goto FailWin

:SuccessWin
echo.
echo %GREEN%=================================================================================%RESET%
echo %GREEN%SIKERES AKTIVALAS! A folyamat befejezodott.                                     %RESET%
echo %GREEN%=================================================================================%RESET%
del "%temp%\kms_win_log.txt" >nul 2>&1
echo.
echo Nyomj meg egy gombot a fomenube valo visszatereshez!
pause >nul
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
if not exist "%OSPP_PATH%" (
    echo %RED%HIBA: Az ospp.vbs fajl nem talalhato a megadott utvonalon!%RESET%
    echo Lehet, hogy nem a megfelelo bites verzio lett kivalasztva, vagy az Office nincs telepitve.
    echo.
    echo Nyomj meg egy gombot a fomenube valo visszatereshez!
    pause >nul
    goto MainMenu
)

echo Uj kulcs telepitese (%O_GVLK%)...
cscript "%OSPP_PATH%" /inpkey:%O_GVLK% //nologo > "%temp%\kms_off_inpkey_log.txt"
type "%temp%\kms_off_inpkey_log.txt"

REM -- Verzio ellenorzes: Sikerult a kulcsot elfogadnia a rendszernek? --
find /i "0xC004F069" "%temp%\kms_off_inpkey_log.txt" >nul
if %errorlevel% equ 0 goto WrongOfficeVersion
find /i "Error" "%temp%\kms_off_inpkey_log.txt" >nul
if %errorlevel% equ 0 goto WrongOfficeVersion
find /i "Hiba" "%temp%\kms_off_inpkey_log.txt" >nul
if %errorlevel% equ 0 goto WrongOfficeVersion

del "%temp%\kms_off_inpkey_log.txt" >nul 2>&1
goto ContinueOfficeAct

:WrongOfficeVersion
echo.
echo %RED%=================================================================================%RESET%
echo %RED%HIBA: A termekkulcsot nem fogadta el a rendszer (SKU not found)!       %RESET%
echo %RED%Valoszinuleg NEM ezt az Office verziot telepitetted a gepre. %RESET%
echo %RED%Kerlek, ellenorizd a gepen levo Office verziojat, es probald ujra a helyes menuponttal.%RESET%
echo %RED%=================================================================================%RESET%
del "%temp%\kms_off_inpkey_log.txt" >nul 2>&1
echo.
echo Nyomj meg egy gombot a fomenube valo visszatereshez!
pause >nul
goto MainMenu

:ContinueOfficeAct
echo Szerver beallitasa: kms.edu.hu...
cscript "%OSPP_PATH%" /sethst:kms.edu.hu //nologo

echo Port beallitasa: 1688...
cscript "%OSPP_PATH%" /setprt:1688 //nologo

:RetryOfficeAct
echo.
echo --------------------------------------------------------
echo Aktivacios kiserlet folyamatban (Office)...
echo --------------------------------------------------------
cscript "%OSPP_PATH%" /act //nologo > "%temp%\kms_off_log.txt"
type "%temp%\kms_off_log.txt"

find /i "Hiba:" "%temp%\kms_off_log.txt" >nul
if %errorlevel% equ 0 goto FailOffice
find /i "Error:" "%temp%\kms_off_log.txt" >nul
if %errorlevel% equ 0 goto FailOffice
find /i "0xC004F074" "%temp%\kms_off_log.txt" >nul
if %errorlevel% equ 0 goto FailOffice

find /i "success" "%temp%\kms_off_log.txt" >nul
if %errorlevel% equ 0 goto SuccessOffice
find /i "siker" "%temp%\kms_off_log.txt" >nul
if %errorlevel% equ 0 goto SuccessOffice

goto FailOffice

:SuccessOffice
echo.
echo %GREEN%=================================================================================%RESET%
echo %GREEN%SIKERES AKTIVALAS! A folyamat befejezodott.                                     %RESET%
echo %GREEN%=================================================================================%RESET%
del "%temp%\kms_off_log.txt" >nul 2>&1
echo.
echo Nyomj meg egy gombot a fomenube valo visszatereshez!
pause >nul
goto MainMenu

:FailOffice
echo.
echo %RED%A szerver nem valaszol, vagy tulterhelt. Ujraprobalkozas 5 masodperc mulva...%RESET%
del "%temp%\kms_off_log.txt" >nul 2>&1
timeout /t 5
goto RetryOfficeAct