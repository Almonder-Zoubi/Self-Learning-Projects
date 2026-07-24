@echo off
setlocal

set "ROOT_DIR=%~dp0"
set "BUILD_DIR=%ROOT_DIR%build"

cmake -S "%ROOT_DIR%" -B "%BUILD_DIR%" -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 exit /b 1

cmake --build "%BUILD_DIR%" --config Release
if errorlevel 1 exit /b 1

if exist "%BUILD_DIR%\Release\Tetris.exe" (
    start "" "%BUILD_DIR%\Release\Tetris.exe"
) else if exist "%BUILD_DIR%\Tetris.exe" (
    start "" "%BUILD_DIR%\Tetris.exe"
)