#!/sbin/busybox sh

BUSYBOX=/sbin/busybox

${BUSYBOX} rm /cache/recovery/boot

## /data
${BUSYBOX} umount -l /dev/block/mmcblk0p31
## /cache
${BUSYBOX} umount -l /dev/block/mmcblk0p30

# Mount recovery partition
cd /
#${BUSYBOX} rm -r /sbin /sdcard
#${BUSYBOX} rm -f etc init* uevent* default*
${BUSYBOX} cp /system/bin/recovery.tar /sbin/
if [ -f "/sbin/recovery.tar" ]; then
	${BUSYBOX} tar -xf /sbin/recovery.tar
fi

# Umount /system

${BUSYBOX} umount -l /dev/block/mmcblk0p28

# Execute recovery INIT
${BUSYBOX} chroot / /init

