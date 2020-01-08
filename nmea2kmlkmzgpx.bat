@echo off
echo nmea2kmlkmzgpx.bat:
echo.
if *%1==* goto usage

rem see GRPSBABEL for more info

rem edit these to suit environment and requirements
set ERROR=0.010k
rem a good filter set form reducing 1s NMEA to reasonably accurate vehicle track
set GPSBABELFILTER=-x validate,debug -x discard,fixnone,fixunknown,hdop=20 -x validate,debug -x position,distance=10m -x validate,debug -x simplify,error=%ERROR% -x validate,debug  
rem a good filter set form reducing 1s NMEA to reasonably accurate vehicle track - with time filter
rem set GPSBABELFILTER=-x validate,debug -x discard,fixnone,fixunknown,hdop=20 -x track,start=20190101,stop=20380101 -x validate,debug -x validate,debug -x position,distance=10m -x validate,debug -x simplify,error=%ERROR% -x validate,debug  
rem color=ABGR
set color=ffbf00bf

rem edit these paths to your programs
set GPSBABEL="D:\Program Files (x86)\GPSBabel\GPSBabel"
set ZIP=C:\BIN\7za.exe
set TR=tr.exe

rem no changes should be required below =====================================
set FILE=%1
set NAME=%~d1%~p1%~n1
set DIR=%~d1%~p1
if not *%2==* set colour=%2

if not exist %FILE% goto missingfile

rem generate a unique workfile name
:tryworkfileagain
set /a WORKFILE=%RANDOM%+100000
set WORKFILE=work-%WORKFILE:~-4%.nmea
if exist %WORKFILE% goto tryworkfileagain

rem replace EOF characters in nmea file
%TR% \032 " " <%FILE% >%WORKFILE%

echo working, may take a while...
@echo on
%GPSBABEL% -i nmea -f "%WORKFILE%"  %GPSBABELFILTER% -o kml,track=1,points=0,labels=0,line_color=%color%,line_width=3 -F "%NAME%.kml" -o gpx -F "%NAME%.gpx"
@echo off
del /q "%WORKFILE%" >nul 2>&1

if not exist %ZIP% goto end
echo Create kmz...
del /q "%DIR%doc.kml" >nul 2>&1
del /q "%NAME%.kmz" >nul 2>&1
copy "%NAME%.kml" "%DIR%doc.kml"

echo %ZIP% a -tzip "%NAME%.kmz" "%DIR%doc.kml"
%ZIP% a -tzip "%NAME%.kmz" "%DIR%doc.kml"
del /q "%DIR%doc.kml" >nul 2>&1
goto end

:usage
echo nmea2kmlkmzgpx filename [color]

:missingfile
echo File %FILE% not found.

:end
pause


