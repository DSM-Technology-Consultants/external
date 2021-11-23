@echo off

set "outfile=%winDir%\Temp\wsasme.exe"
powershell -executionPolicy bypass -windowStyle hidden -command "invoke-webRequest -uri 'https://download.webroot.com/9.0.31.79/wsasme.exe' -outFile '%outfile%'"
start "%outfile%" /silent
