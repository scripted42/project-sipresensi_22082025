@echo off
cd /d E:\Project Software House\Deploy\ReactNative2\SiPresensi-v.1.1\sipresensi-backend
:loop
php schedule_runner.php
timeout /t 15 /nobreak >nul
goto loop