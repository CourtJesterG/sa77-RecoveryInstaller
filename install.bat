@echo off
cls
COLOR B
echo ** Recovery Installer for Xperia L - v1.8 **
echo **    By Rachit Rawat and [NUT]           ** 
echo.

echo.
echo ===============================================
echo Connect device with USB debugging on...
echo ===============================================

cd files
adb kill-server
adb start-server
adb wait-for-device
echo Device Detected.
echo.

:menu
echo 1. Install CWM recovery
echo 2. Install TWRP recovery
echo 3. Install philZ recovery
echo 4. Install some other recovery
echo 5. Uninstall existing recovery
echo 6. View XDA thread
echo 7. Exit
SET /P M=Enter your choice:
echo.
IF %M%==1 GOTO one
IF %M%==2 GOTO two
IF %M%==3 GOTO three
IF %M%==4 GOTO four
IF %M%==5 GOTO five
IF %M%==6 GOTO six
IF %M%==7 GOTO seven

:one
echo =============================================
echo Installing CWM recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/recovery"
adb push recovery.sh /data/local/tmp/recovery
adb push e2fsck.sh /data/local/tmp/recovery
adb push cwm/recovery.tar /data/local/tmp/recovery
adb push busybox /data/local/tmp/recovery
adb push step3.sh /data/local/tmp/recovery
adb shell "chmod 755 /data/local/tmp/recovery/busybox"
adb shell "chmod 755 /data/local/tmp/recovery/step3.sh"
adb shell "su -c /data/local/tmp/recovery/step3.sh"
adb shell "rm -r /data/local/tmp/recovery"

adb kill-server

echo.
echo Finished!
echo.
goto menu

:two
echo =============================================
echo Installing twrp recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/recovery"
adb push recovery.sh /data/local/tmp/recovery
adb push e2fsck.sh /data/local/tmp/recovery
adb push twrp/recovery.tar /data/local/tmp/recovery
adb push busybox /data/local/tmp/recovery
adb push step3.sh /data/local/tmp/recovery
adb shell "chmod 755 /data/local/tmp/recovery/busybox"
adb shell "chmod 755 /data/local/tmp/recovery/step3.sh"
adb shell "su -c /data/local/tmp/recovery/step3.sh"
adb shell "rm -r /data/local/tmp/recovery"

adb kill-server

echo.
echo Finished!
echo.
goto menu

:three
echo =============================================
echo Installing philZ recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/recovery"
adb push recovery.sh /data/local/tmp/recovery
adb push e2fsck.sh /data/local/tmp/recovery
adb push philz/recovery.tar /data/local/tmp/recovery
adb push busybox /data/local/tmp/recovery
adb push step3.sh /data/local/tmp/recovery
adb shell "chmod 755 /data/local/tmp/recovery/busybox"
adb shell "chmod 755 /data/local/tmp/recovery/step3.sh"
adb shell "su -c /data/local/tmp/recovery/step3.sh"
adb shell "rm -r /data/local/tmp/recovery"

adb kill-server

echo.
echo Finished!
echo.
goto menu

:four
echo Place your recovery.tar in files/input folder and press enter.
mkdir input
pause>>null
echo =============================================
echo Installing recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/recovery"
adb push recovery.sh /data/local/tmp/recovery
adb push e2fsck.sh /data/local/tmp/recovery
adb push input/recovery.tar /data/local/tmp/recovery
adb push busybox /data/local/tmp/recovery
adb push step3.sh /data/local/tmp/recovery
adb shell "chmod 755 /data/local/tmp/recovery/busybox"
adb shell "chmod 755 /data/local/tmp/recovery/step3.sh"
adb shell "su -c /data/local/tmp/recovery/step3.sh"
adb shell "rm -r /data/local/tmp/recovery"
echo 
echo Finished!
echo.
goto menu
   
:five
echo =============================================
echo Uninstalling recovery..
echo =============================================
adb shell "mkdir /data/local/tmp/recovery"
adb push busybox /data/local/tmp/recovery
adb push unin.sh /data/local/tmp/recovery
adb shell "chmod 755 /data/local/tmp/recovery/busybox"
adb shell "chmod 755 /data/local/tmp/recovery/unin.sh"
adb shell "su -c /data/local/tmp/recovery/unin.sh"
adb shell "rm -r /data/local/tmp/recovery"
echo. 
echo Finished!
echo.
goto menu

:six
start http://forum.xda-developers.com/xperia-l/orig-development/cwm-recovery-installer-t2589320
goto menu

:seven
exit
