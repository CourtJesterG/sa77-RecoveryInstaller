#!/data/local/tmp/cwm/busybox sh
BUSYBOX=/data/local/tmp/cwm/busybox
${BUSYBOX} mount -o remount,rw /system
${BUSYBOX} rm -f /system/bin/recovery.tar
${BUSYBOX} rm -f /system/bin/recovery.sh
if [ -e /system/bin/e2fsck.bin ]; then
${BUSYBOX} mv /system/bin/e2fsck.bin /system/bin/e2fsck
fi
