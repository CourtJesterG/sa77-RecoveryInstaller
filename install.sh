setterm -bold

echo "** Recovery Installer for Xperia L - v1.5 **"
echo "**    By Rachit Rawat and [NUT]           **"
echo 
cd files

echo
echo ===============================================
echo Step1 : Connect device with usb debugging on...
echo ===============================================
adb wait-for-device
echo Device Detected.
echo

while :
do
tput setaf 6
setterm -bold
echo "1. Install CWM"
echo "2. Install philZ recovery"
echo "3. Install some other recovery"
echo "4. Uninstall existing recovery"
echo "5. View XDA thread"
echo "6. Exit"
tput sgr0
printf "Enter choice:"
read ANS

case $ANS in
1) 

adb kill-server
adb start-server

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

echo
echo Finished!
echo
;;

2) 

adb kill-server
adb start-server

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

echo
echo Finished!
echo
;;

3) 
if ! test -d ../input
then mkdir ../input
fi

echo Place your recovery.tar in input folder and press enter.
read ANS2
if test  -e ../input/recovery.tar
   then echo "Recovery found."
echo =============================================
echo Step2 : Installing recovery...
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

4) echo "Uninstalling recovery.."
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

5) 
if which xdg-open > /dev/null
then
  xdg-open http://forum.xda-developers.com/xperia-l/development/cwm-recovery-installer-t2589320
elif which gnome-open > /dev/null
then
  gnome-open URL
fi
;;

6) 
exit
;;

esac
done
