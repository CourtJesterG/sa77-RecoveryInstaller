@echo off
rem ***********************************************************************
rem ***********************************************************************
rem 
rem                 CWM Recovery for Xperia L
rem                           Rachit Rawat
rem ***********************************************************************
rem ***********************************************************************

cd files

adb kill-server
adb start-server

echo =============================================
echo Step1 : Waiting for Device...
echo =============================================
adb wait-for-device
echo Device Detected
echo.

echo =============================================
echo Step2 : Sending some files...
echo =============================================
adb shell "mkdir /data/local/tmp/cwm"
adb push install-recovery.sh /data/local/tmp/cwm
adb push sa77_recovery /data/local/tmp/cwm
adb push recovery.sh /data/local/tmp/cwm
adb push recovery.tar /data/local/tmp/cwm
adb push busybox /data/local/tmp/cwm
adb push step3.sh /data/local/tmp/cwm

echo.
echo =============================================
echo Step3 : Setting up files...
echo =============================================
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/step3.sh"
adb shell "su -c /data/local/tmp/cwm/step3.sh"
adb shell "rm -r /data/local/tmp/cwm"

adb kill-server

echo Finished!

pause
