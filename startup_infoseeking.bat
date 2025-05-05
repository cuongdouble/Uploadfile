@echo off
setlocal EnableDelayedExpansion

:: Archive Chrome logs
powershell.exe C:\kiosk\archive-chrome-logs.ps1

:: Define URLs and flags
set targetUrl="https://idd.taikooplace.com/kiosklogin/%COMPUTERNAME%"
set errorUrl="https://localhost:11198/error.html"
set connected=FALSE

set chromePath="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
set chromeParams=--kiosk --incognito --check-for-update-interval=604800 --simulate-outdated-no-au="01 Jan 2032" --no-first-run --disable-session-crashed-bubble --disable-infobars --disable-translate --disable-tab-switcher --disable-pinch --overscroll-history-navigation=0 --disable-background-timer-throttling --disable-renderer-backgrounding --disable-features=FreezeUserAgent,CalculateNativeWinOcclusion --disable-backgrounding-occluded-windows --enable-gpu-rasterization --force-compositing-mode --enable-logging --v=1

:: Enumerate and test all connected interfaces
echo.
echo [%date% %time%] Enumerating interfaces...

for /f "tokens=*" %%i in ('powershell -NoProfile -Command ^
  "(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.MediaConnectionState -eq 'Connected' }) | Select-Object -ExpandProperty Name"') do (
    set "candidateInterface=%%i"
    call :TestInterface
    if "!connected!"=="TRUE" goto found_interface
)

goto no_working_interface

:TestInterface
echo.
echo Testing interface: !candidateInterface!
powershell -NoProfile -Command ^
    "if (Test-Connection -Count 1 -Quiet -ComputerName 8.8.8.8) { exit 0 } else { exit 1 }" >nul 2>&1
if not errorlevel 1 (
    echo !candidateInterface! has internet access
    set "networkInterface=!candidateInterface!"
    set "connected=TRUE"
) else (
    echo !candidateInterface! has no internet access
)
goto :eof

:found_interface
echo.
@echo [%date% %time%] Found working interface: %networkInterface%
goto after_interface

:no_working_interface
echo.
@echo [%date% %time%] No network interface with internet access was found.
goto after_interface

:after_interface

@echo [%date% %time%] Target URL: %targetUrl%
@echo [%date% %time%] Network Interface: %networkInterface%
@echo [%date% %time%] Connected: %connected%

if %connected%==FALSE (
    @echo [%date% %time%] Launching: Offline mode
) else (
    @echo [%date% %time%] Launching: Connected mode
)

@echo [%date% %time%] Checking LMS service...
FOR /L %%G IN (1,1,40) DO (
    @echo|set /p="."
    curl -L --silent --max-time 3 https://localhost:11198/api/heartbeat >nul 2>&1 && (
        goto end_of_lms_check
    )
)
:end_of_lms_check

:: Launch supporting tools
cd \
cd C:\kiosk

Start autohotkey.ahk

REGEDIT /S tabletmodeoff.reg

:: Final launch
if %connected%==FALSE (
    @echo [%date% %time%] Launching: Local Error Page		
powershell -ExecutionPolicy Bypass -File C:\kiosk\update_targeturl.ps1
    %chromePath% %chromeParams% "%errorUrl%"
) else (
    @echo [%date% %time%] Launching: Target URL
	%chromePath% %chromeParams% "%targetUrl%"
)

endlocal
Exit