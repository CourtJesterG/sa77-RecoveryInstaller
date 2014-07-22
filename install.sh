setterm -bold
VER="1.8"
ADB_WAIT="adb wait-for-device"
ADB_KILL="adb kill-server"
ADB_START="adb start-server"
ADB_PULL="adb pull /system/build.prop"
CHECK_DEVICE="ro.semc.product.name"
CHECK_DEVICE_TAOSHAN="ro.semc.product.name=Xperia L"
CHECK_FIRMWARE="ro.build.id="

echo "** Recovery Installer for Xperia L - $VER   **"
echo "**        By Rachit Rawat and [NUT]        **"
echo 
cd files

echo
echo ===============================================
echo Connect device with USB debugging on...
echo ===============================================

eval $ADB_WAIT

# Pull build.prop
eval $ADB_PULL
echo

# Check if correct device is connected
if ! grep -q "$CHECK_DEVICE_TAOSHAN" build.prop
then
STR=$(grep "$CHECK_DEVICE" build.prop)
echo "${STR##*=} is not supported!"
rm build.prop
else
STR=$(grep "$CHECK_DEVICE" build.prop)
echo "Device : ${STR##*=}"
STR2=$(grep "$CHECK_FIRMWARE" build.prop)
echo "FW : ${STR2##*=}"
rm build.prop

echo

while :
do
tput setaf 6
setterm -bold
echo "1. Install CWM recovery"
echo "2. Install TWRP recovery"
echo "3. Install philZ recovery"
echo "4. Install some other recovery"
echo "5. Uninstall existing recovery"
echo "6. View XDA thread"
echo "7. Exit"
tput sgr0
printf "Enter choice:"
read ANS

case $ANS in
1) 

echo =============================================
echo Installing CWM recovery...
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

echo
echo Finished!
echo
;;

2) 

echo =============================================
echo Installing TWRP recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/cwm"
adb push recovery.sh /data/local/tmp/cwm
adb push e2fsck.sh /data/local/tmp/cwm
adb push twrp/recovery.tar /data/local/tmp/cwm
adb push busybox /data/local/tmp/cwm
adb push step3.sh /data/local/tmp/cwm
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/step3.sh"
adb shell "su -c /data/local/tmp/cwm/step3.sh"
adb shell "rm -r /data/local/tmp/cwm"

echo
echo Finished!
echo
;;

3) 

echo =============================================
echo Installing philZ recovery...
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

echo
echo Finished!
echo
;;

4) 

if [ ! -d ../input ]
then mkdir ../input
fi

echo "Place your recovery.tar in input folder and press enter"
read ANS2
if test  -e ../input/recovery.tar
   then echo "Recovery found."
echo =============================================
echo Installing recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/cwm"
adb push recovery.sh /data/local/tmp/cwm
adb push e2fsck.sh /data/local/tmp/cwm
adb push ../input/recovery.tar /data/local/tmp/cwm
adb push busybox /data/local/tmp/cwm
adb push step3.sh /data/local/tmp/cwm
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/step3.sh"
adb shell "su -c /data/local/tmp/cwm/step3.sh"
adb shell "rm -r /data/local/tmp/cwm"
echo 
echo Finished!
else echo "Recovery not found!"
   exit 
fi
;;

5) 

echo =============================================
echo Uninstalling recovery...
echo =============================================
adb shell "mkdir /data/local/tmp/cwm"
adb push busybox /data/local/tmp/cwm
adb push unin.sh /data/local/tmp/cwm
adb shell "chmod 755 /data/local/tmp/cwm/busybox"
adb shell "chmod 755 /data/local/tmp/cwm/unin.sh"
adb shell "su -c /data/local/tmp/cwm/unin.sh"
adb shell "rm -r /data/local/tmp/cwm"
echo 
echo "Finished!"
;;

6) 

if which xdg-open > /dev/null
then
  xdg-open http://forum.xda-developers.com/xperia-l/orig-development/cwm-recovery-installer-t2589320
elif which gnome-open > /dev/null
then
  gnome-open URL
fi
;;

7)
 
exit
;;

esac

done

fi

echo Auto exit in 3 seconds!
sleep 3
