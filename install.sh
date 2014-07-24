setterm -bold
VER="1.8"
ADB_WAIT="adb wait-for-device"
ADB_KILL="adb kill-server"
ADB_START="adb start-server"
ADB_PULL="adb pull /system/build.prop"
CHECK_DEVICE="ro.semc.product.name"
CHECK_DEVICE_TAOSHAN="ro.semc.product.name=Xperia L"
CHECK_FIRMWARE="ro.build.id="
APK_PATH="tr_download/tr.apk"
STATUS_ROOT="No"

init(){
echo "** Recovery Installer for Xperia L - $VER   **"
echo "**        By rachitrawat and [NUT]         **"
echo 
echo 
printf "Initializing"; sleep 1; printf ".."; sleep 1; printf ".."; sleep 1;
cd files
}

eval_it(){
eval $1
} > /dev/null

adb_detect(){
clear
echo
echo "==============================================="
echo "Connect device with USB debugging on..."
echo "==============================================="

eval_it "$ADB_WAIT"
}

adb_pull_prop(){
# Pull build.prop
eval_it "$ADB_PULL"

# Check if build.prop pull was successful
if [ $? -ne 0 ]; then
echo "Cannot obtain build.prop for device."
exit_menu;
fi

# Check if correct device is connected
if ! grep -q "$CHECK_DEVICE_TAOSHAN" build.prop
then
STR=$(grep "$CHECK_DEVICE" build.prop)
echo
echo "WARNING: ${STR##*=} is not supported!"
read -p "Do you still want to continue? (y/n) " choice
case "$choice" in 
y|Y ) 
write_prop
;;
*)
exit_menu
;;
esac
else
write_prop;
fi
}

write_prop(){
STR=$(grep "$CHECK_DEVICE" build.prop)
STR2=$(grep "$CHECK_FIRMWARE" build.prop)
}

check_for_su(){
# Check for su
echo 
eval_it "adb pull /system/xbin/su"

# Prompt if su is not found
if [ $? -ne 0 ]; then
   echo "Device is not rooted. Root access is required to proceed furthur."
   read -p "Do you want to root it via towelroot? (y/n)" choice
   case "$choice" in 
   y|Y ) echo "\nRooting device..."
           # Check for a working internet connection
           COUNTER=0
           wget -q --tries=20 --timeout=10 http://www.google.com -O test.idx
           if [ -s test.idx ]; then
           COUNTER=1
           echo "Working Internet Connection Available!"
           echo "Downloading latest towelroot apk..."
     
           # Download latest towelroot apk 
           wget -P tr_download/ https://towelroot.com/tr.apk
           if [ $? -ne 0 ]; then
               COUNTER=0
           fi 

           # If working internet is not available or apk download somehow failed
           elif [ "$COUNTER" -eq 0 ]; then
           echo "Unable to download apk from Internet!"
           echo "Using built-in version of apk!"
           APK_PATH="tr.apk"
           fi
          
           # Install apk
           echo "Installing towerlroot apk..."
           eval_it "adb install $APK_PATH"
           # remove tr_download dir if found
           if [ -d tr_download ]; then
                  rm -rf tr_download
           fi
           # Run TowelRoot activity
           eval_it "adb shell am start -n com.geohot.towelroot/.TowelRoot"
           echo "Click make it rain and press enter.."
           read ch

           # Double Check for root
           echo "Verifying root.."
           eval_it "adb pull /system/xbin/su"
           if [ $? -ne 0 ]; then
             echo "Root not found. Exiting..."
             exit_menu;
           else
             STATUS_ROOT="Yes"
           fi
           ;;

  n|N|* ) echo "Fail! Cannot proceed without root access."
          exit_menu ;;
esac
else
             STATUS_ROOT="Yes"
fi

echo
}

# main_menu function definition
main_menu(){
# Remove temp files once we reach main menu
rm_temp
clear;
echo 
echo "Device      : ${STR##*=}"
echo "FW          : ${STR2##*=}"
echo "Root access : $STATUS_ROOT"
echo
while :
do
tput setaf 6
setterm -bold
echo "1. Install a recovery"
echo "2. Uninstall existing recovery"
echo "3. View XDA thread"
echo "4. Exit"
tput sgr0
printf "Enter choice:"
read ANS

case $ANS in

1) 
     # Call recovery_menu function
     recovery_menu;;

2) 

echo "============================================="
echo "Uninstalling recovery..."
echo "============================================="
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

3) 

if which xdg-open > /dev/null
then
  eval_it "xdg-open http://forum.xda-developers.com/xperia-l/orig-development/cwm-recovery-installer-t2589320"
elif which gnome-open > /dev/null
then
  gnome-open URL
fi
echo
;;

4)
 
exit
;;

esac

done
}

# recovery_menu function definition
recovery_menu(){
clear
echo "============================================="
echo "Available Recovery Options"
echo "============================================="
tput setaf 6
setterm -bold
echo "1. Install CWM recovery"
echo "2. Install TWRP recovery"
echo "3. Install philZ recovery"
echo "4. Install custom recovery.tar"
echo "5. Back"

tput sgr0
printf "Enter choice:"
read ANS3

case $ANS3 in
1)
echo "============================================="
echo "Installing CWM recovery..."
echo "============================================="
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
echo "Finished!"
echo
;;

2) 

echo "============================================="
echo "Installing TWRP recovery..."
echo "============================================="
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
echo "Finished!"
echo
;;

3) 

echo "============================================="
echo "Installing philZ recovery..."
echo "============================================="
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
echo "Finished!"
echo
;;

4) 

if [ ! -d ../input ]
then mkdir ../input
fi

echo "Place your recovery.tar in input folder and press enter"
read ANS2
if [ -e ../input/recovery.tar ]; then
   echo "Recovery found."
echo "============================================="
echo "Installing recovery..."
echo "============================================="
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
echo "Finished!"
else 
     echo "Recovery not found!"
     exit_menu
fi
;;

5)
     clear
     main_menu;;
esac
}

exit_menu(){
echo "Auto exit in 3 seconds!"
sleep 3
exit 1;
}

rm_temp(){
rm -f build.prop
rm -f su
rm -f test.idx
rm -rf tr_download
}

# call functions
rm_temp
init
adb_detect
adb_pull_prop
write_prop
check_for_su
main_menu

# End
