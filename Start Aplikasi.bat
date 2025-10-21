@echo off
:: Batch file untuk menjalankan PowerShell GUI sebagai Administrator

echo ================================================
echo   Install Password Lock Tool - GUI Version
echo   Menjalankan sebagai Administrator...
echo ================================================
echo.

:: Cek apakah sudah running sebagai admin
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running dengan hak Administrator
    echo [OK] Membuka GUI...
    echo.
    powershell.exe -ExecutionPolicy Bypass -File "%~dp0InstallPasswordLock-GUI.ps1"
) else (
    echo [!] Memerlukan hak Administrator...
    echo [!] Meminta elevasi...
    echo.
    :: Request admin privileges
    powershell.exe -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

exit


