#!/data/local/tmp/cwm/busybox sh

BUSYBOX=/data/local/tmp/cwm/busybox

echo "remount /system writable"
${BUSYBOX} mount -o remount,rw /system

echo "copy busybox to system."
${BUSYBOX} cp /data/local/tmp/cwm/busybox /system/xbin/busybox
${BUSYBOX} chmod 755 /system/xbin/busybox

echo "copy recovery.tar to system."
${BUSYBOX} cp /data/local/tmp/cwm/recovery.tar /system/bin/recovery.tar
chmod 644 /system/bin/recovery.tar

echo "copy e2fsck replacement to system."
if [ ! -f "/system/bin/e2fsck.bin" ]; then
	${BUSYBOX} mv /system/bin/e2fsck /system/bin/e2fsck.bin
fi
${BUSYBOX} cp /data/local/tmp/cwm/e2fsck.sh /system/bin/e2fsck
${BUSYBOX} chmod 755 /system/bin/e2fsck

echo "copy recovery script to system."
${BUSYBOX} cp /data/local/tmp/cwm/recovery.sh /system/bin/recovery.sh
${BUSYBOX} chmod 755 /system/bin/recovery.sh

echo "remount /system read only"
${BUSYBOX} mount -o remount,ro /system
