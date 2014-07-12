@echo off
cls
COLOR B
echo ** Recovery Installer for Xperia L - v1.7 **
echo **    By Rachit Rawat and [NUT]           ** 
echo.

echo.
echo ===============================================
echo Step1 : Connect device with usb debugging on...
echo ===============================================

cd files
adb kill-server
adb start-server
adb wait-for-device
echo Device Detected.
echo.

:menu
echo 1. Install CWM recovery
echo 2. Install philZ recovery
echo 3. Install some other recovery
echo 4. Uninstall existing recovery
echo 5. View XDA thread
echo 6. Exit
SET /P M=Enter your choice:
echo.
IF %M%==1 GOTO one
IF %M%==2 GOTO two
IF %M%==3 GOTO three
IF %M%==4 GOTO four
IF %M%==5 GOTO five
IF %M%==6 GOTO six

:one
echo =============================================
echo Step2 : Installing CWM recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/cwm"
adb push recovery.sh /data/local/tmp/cwm
adb push e2fsck.sh /data/local/tmp/cwm
adb push cwm/recovery.tar /data/local/tmp/cwm
adb push busybox /data/local/tmp/cwm
adb push step3.sh /data/local/tmp/cwm
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/step3.sh"
adb shell "su -c /data/local/tmp/cwm/step3.sh"
adb shell "rm -r /data/local/tmp/cwm"

adb kill-server

echo.
echo Finished!
echo.
goto menu

:two
echo =============================================
echo Step2 : Installing philZ recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/cwm"
adb push recovery.sh /data/local/tmp/cwm
adb push e2fsck.sh /data/local/tmp/cwm
adb push philz/recovery.tar /data/local/tmp/cwm
adb push busybox /data/local/tmp/cwm
adb push step3.sh /data/local/tmp/cwm
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/step3.sh"
adb shell "su -c /data/local/tmp/cwm/step3.sh"
adb shell "rm -r /data/local/tmp/cwm"

adb kill-server

echo.
echo Finished!
echo.
goto menu

:three
echo Place your recovery.tar in files/input folder and press enter.
mkdir input
pause>>null
echo =============================================
echo Step2 : Installing recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/cwm"
adb push recovery.sh /data/local/tmp/cwm
adb push e2fsck.sh /data/local/tmp/cwm
adb push input/recovery.tar /data/local/tmp/cwm
adb push busybox /data/local/tmp/cwm
adb push step3.sh /data/local/tmp/cwm
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/step3.sh"
adb shell "su -c /data/local/tmp/cwm/step3.sh"
adb shell "rm -r /data/local/tmp/cwm"
echo 
echo Finished!
echo.
goto menu
   
:four
echo Uninstalling recovery..
adb shell "mkdir /data/local/tmp/cwm"
adb push busybox /data/local/tmp/cwm
adb push unin.sh /data/local/tmp/cwm
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/unin.sh"
adb shell "su -c /data/local/tmp/cwm/unin.sh"
adb shell "rm -r /data/local/tmp/cwm"
echo. 
echo Finished!
echo.
goto menu

:five
start http://forum.xda-developers.com/xperia-l/orig-development/cwm-recovery-installer-t2589320
goto menu

:six
exit
