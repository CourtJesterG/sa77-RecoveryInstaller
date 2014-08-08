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
FILE=`dirname $0`/README.md
zenity --text-info \
       --title="Disclaimer" \
       --filename=$FILE \
       --checkbox="I read and accept the terms."

case $? in
    1) 
        exit;;
esac
cd files
echo "Version=v${VER}" > recovery-version.txt
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
FLAG="Cannot obtain build.prop for device."
exit_menu "$FLAG";
fi

# Check if correct device is connected
if ! grep -q "$CHECK_DEVICE_TAOSHAN" build.prop
then
STR=$(grep "$CHECK_DEVICE" build.prop)
echo
zenity --question --text="WARNING: ${STR##*=} is not supported!\nDo you still want to continue?"
case "$?" in 
0) 
write_prop
;;
*)
FLAG="Unsupported Device!"
exit_menu "$FLAG"
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

check_prev_install(){
eval_it "adb pull /system/bin/recovery-version.txt"
if [ $? -eq 0 ]; then
is_installed="Yes"
PREV_VINFO=$(grep "Version" recovery-version.txt)
else
is_installed="No"
PREV_VINFO=""
fi
}

check_for_su(){
# Check for su
echo 
eval_it "adb pull /system/xbin/su"

# Prompt if su is not found
if [ $? -ne 0 ]; then
   zenity --question --text="Device is not rooted! Root access is required to proceed furthur.\nDo you want to root it via towelroot?"
   case "$?" in 
   0 ) echo "\nRooting device..."
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
             FLAG="Root not found. Exiting..."
             exit_menu "$FLAG";
           else
             STATUS_ROOT="Yes"
           fi
           ;;

  * ) FLAG="Fail! Cannot proceed without root access."
          exit_menu "$FLAG";;
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
echo "Device           : ${STR##*=}"
echo "FW               : ${STR2##*=}"
echo "Root access      : $STATUS_ROOT"
echo "Has Recovery     : ${is_installed} ${PREV_VINFO##*=}" 
echo
while :
do
tput setaf 6
setterm -bold
echo "1. Install a recovery"
echo "2. Uninstall existing recovery"
echo "3. View XDA thread"
echo "4. About"
echo "5. Exit"
tput sgr0
printf "Enter choice:"
read ANS

case $ANS in

1) 
     # Call recovery_menu function
     recovery_menu;;

2) 

(echo "20";
adb shell "mkdir /data/local/tmp/recovery"
adb push busybox /data/local/tmp/recovery
adb push unin.sh /data/local/tmp/recovery
echo "40";
adb shell "chmod 755 /data/local/tmp/recovery/busybox"
adb shell "chmod 755 /data/local/tmp/recovery/unin.sh"
echo "60";
adb shell "su -c /data/local/tmp/recovery/unin.sh"
adb shell "rm -r /data/local/tmp/recovery"
echo "80"; ) | zenity --progress --text="Uninstalling recovery" --percentage=0 --auto-close
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
zenity --info --title="Recovery Installer v1.8" --text="Programmed by rachitrawat\nContributors: [NUT]"
 
;;

5) exit
;;

esac

done
}

# recovery_menu function definition
recovery_menu(){
OUTPUT=$(zenity --list \
 --title="Choose desired recovery" \
 --column="Recovery" --column="Version" \
  CWM 6.0.5.0 \
  TWRP 2.7.0 \
  Philz 6.47.6 \
  Custom -) 

case $OUTPUT in
"CWM")
(echo "20";
adb shell "mkdir /data/local/tmp/recovery";
adb push recovery.sh /data/local/tmp/recovery;
adb push e2fsck.sh /data/local/tmp/recovery;
echo "40";
adb push cwm/recovery.tar /data/local/tmp/recovery;
adb push busybox /data/local/tmp/recovery;
adb push step3.sh /data/local/tmp/recovery;
adb push recovery-version.txt /data/local/tmp/recovery;
echo "60";
adb shell "chmod 755 /data/local/tmp/recovery/busybox";
adb shell "chmod 755 /data/local/tmp/recovery/step3.sh";
adb shell "su -c /data/local/tmp/recovery/step3.sh";
adb shell "rm -r /data/local/tmp/recovery";
echo "80";) | zenity --progress --text="Installing $OUTPUT recovery" --percentage=0 --auto-close
echo "Finished!"
echo
;;

"TWRP") 
(echo "20";
adb shell "mkdir /data/local/tmp/recovery";
adb push recovery.sh /data/local/tmp/recovery;
adb push e2fsck.sh /data/local/tmp/recovery;
echo "40";
adb push twrp/recovery.tar /data/local/tmp/recovery;
adb push busybox /data/local/tmp/recovery;
adb push step3.sh /data/local/tmp/recovery;
adb push recovery-version.txt /data/local/tmp/recovery;
echo "60";
adb shell "chmod 755 /data/local/tmp/recovery/busybox";
adb shell "chmod 755 /data/local/tmp/recovery/step3.sh";
adb shell "su -c /data/local/tmp/recovery/step3.sh";
adb shell "rm -r /data/local/tmp/recovery";
echo "80";) | zenity --progress --text="Installing $OUTPUT recovery" --percentage=0 --auto-close
echo "Finished!"
echo
;;

"Philz") 
(echo "20";
adb shell "mkdir /data/local/tmp/recovery";
adb push recovery.sh /data/local/tmp/recovery;
adb push e2fsck.sh /data/local/tmp/recovery;
echo "40";
adb push philz/recovery.tar /data/local/tmp/recovery;
adb push busybox /data/local/tmp/recovery;
adb push step3.sh /data/local/tmp/recovery;
adb push recovery-version.txt /data/local/tmp/recovery;
echo "60";
adb shell "chmod 755 /data/local/tmp/recovery/busybox";
adb shell "chmod 755 /data/local/tmp/recovery/step3.sh";
adb shell "su -c /data/local/tmp/recovery/step3.sh";
adb shell "rm -r /data/local/tmp/recovery";
echo "80";) | zenity --progress --text="Installing $OUTPUT recovery" --percentage=0 --auto-close
echo "Finished!"
echo
;;

"Custom") 
DIR_CUSTOM=$(zenity --file-selection --title="Select recovery.tar for installation")

if [ -f $DIR_CUSTOM ] && [ "${DIR_CUSTOM##*.}" = "tar" ];then
     mkdir -p input
     cp $DIR_CUSTOM input/recovery.tar
     adb shell "mkdir /data/local/tmp/recovery"
     adb push recovery.sh /data/local/tmp/recovery
     adb push e2fsck.sh /data/local/tmp/recovery
     adb push input/recovery.tar /data/local/tmp/recovery
     adb push busybox /data/local/tmp/recovery
     adb push step3.sh /data/local/tmp/recovery
     adb push recovery-version.txt /data/local/tmp/recovery
     adb shell "chmod 755 /data/local/tmp/recovery/busybox"
     adb shell "chmod 755 /data/local/tmp/recovery/step3.sh"
     adb shell "su -c /data/local/tmp/recovery/step3.sh"
     adb shell "rm -r /data/local/tmp/recovery"
     echo 
     echo "Finished!"
else
     FLAG="recovery.tar not found or invalid format!"
     exit_menu "$FLAG";
fi
;;

5)
     clear
     main_menu;;
esac
}

exit_menu(){
zenity --error --text="$1"
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
check_prev_install
main_menu

# End
