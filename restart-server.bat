@echo off
echo Workspace Root: %CD%
echo Killing existing server...
taskkill /F /IM samp-server.exe >nul 2>&1
if errorlevel 1 (
    echo No server process found.
) else (
    echo Server killed successfully.
)
echo Starting server...
start "" /MIN /D "C:\Users\gusta\OneDrive\Documentos\Scripts\gpbfreeroam" samp-server.exe
if errorlevel 1 (
    echo Failed to start server.
) else (
    echo Server started successfully.
)
