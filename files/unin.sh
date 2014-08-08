#!/data/local/tmp/recovery/busybox sh
BUSYBOX=/data/local/tmp/recovery/busybox
${BUSYBOX} mount -o remount,rw /system
${BUSYBOX} rm -f /system/bin/recovery.tar
${BUSYBOX} rm -f /system/bin/recovery.sh
${BUSYBOX} rm -f /system/bin/recovery-version.txt
if [ -e /system/bin/e2fsck.bin ]; then
${BUSYBOX} mv /system/bin/e2fsck.bin /system/bin/e2fsck
fi
${BUSYBOX} mount -o remount,ro /system
