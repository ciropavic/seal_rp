git add -A
for /F "tokens=2" %%i in ('date /t') do set mydate=%%i
set mytime=%time%
git commit -m "Server backup %mydate%:%mytime%"
git push origin master
pause