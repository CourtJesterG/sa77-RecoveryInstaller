#!/sbin/busybox sh

BUSYBOX=/sbin/busybox

${BUSYBOX} rm /cache/recovery/boot

## /data
${BUSYBOX} umount -l /dev/block/mmcblk0p31
## /cache
${BUSYBOX} umount -l /dev/block/mmcblk0p30

# Mount recovery partition
cd /
rm -r /sbin /sdcard
rm -f etc init* uevent* default*
if [ -f /system/bin/recovery.tar ]; then
	tar -xf /system/bin/recovery.tar
fi

# Umount /system
umount -l /dev/block/mmcblk0p28

# Execute recovery INIT
exec /init
