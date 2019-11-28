@echo off
if *%1==* goto usage

set ERROR=0.005k
set FILE=%1
set NAME=%~d1%~p1%~n1
set colour=ffbf00bf
if not *%2==* set colour=%2
set GPSBABEL="D:\Program Files (x86)\GPSBabel\GPSBabel"
set ZIP=7za.exe

echo working, may take a while...
%GPSBABEL%  -i nmea -f %FILE% -x simplify,error=%ERROR% -x transform,rte=trk,del -x discard,fixnone,fixunknown -o kml,track=1,points=0,labels=0,line_color=%colour%,line_width=3 -F "%NAME%.kml" -o gpx -F "%NAME%.gpx"
goto end

:usage
echo nmea2kmlgpx filename [color]

:end
pause


