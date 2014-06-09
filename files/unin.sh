#!/data/local/tmp/cwm/busybox sh
BUSYBOX=/data/local/tmp/cwm/busybox
${BUSYBOX} mount -o remount,rw /system
${BUSYBOX} rm /system/bin/recovery.tar
${BUSYBOX} rm /system/bin/e2fsck
${BUSYBOX} rm /system/bin/recovery.sh
${BUSYBOX} mv /system/bin/e2fsck.bin /system/bin/e2fsck
