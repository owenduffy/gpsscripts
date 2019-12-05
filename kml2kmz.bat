@echo off
if *%1==* goto usage

set ZIP=C:\BIN\7za.exe

set FILE=%1
set NAME=%~d1%~p1%~n1
set DIR=%~d1%~p1

if not exist %FILE% goto missingfile

if not exist %ZIP% goto end
echo Create kmz...
del /q "%DIR%doc.kml" >nul 2>&1
del /q "%NAME%.kmz" >nul 2>&1
copy "%NAME%.kml" "%DIR%doc.kml"
echo %ZIP% a -tzip "%NAME%.kmz" "%DIR%doc.kml"
%ZIP% a -tzip "%NAME%.kmz" "%DIR%doc.kml"
del /q "%DIR%doc.kml"
goto end

:usage
echo kml2kmz filename [color]

:missingfile
echo File %FILE% not found.

:end
pause


