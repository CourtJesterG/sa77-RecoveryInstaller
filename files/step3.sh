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

echo "copy script to system."
${BUSYBOX} cp /data/local/tmp/cwm/install-recovery.sh /system/etc/install-recovery.sh
${BUSYBOX} chmod 755 /system/etc/install-recovery.sh

echo "copy binary to system."
${BUSYBOX} cp /data/local/tmp/cwm/sa77_recovery /system/bin/sa77_recovery
${BUSYBOX} chmod 755 /system/bin/sa77_recovery

echo "copy recovery script to system."
${BUSYBOX} cp /data/local/tmp/cwm/recovery.sh /system/bin/recovery.sh
${BUSYBOX} chmod 755 /system/bin/recovery.sh

echo "remount /system read only"
${BUSYBOX} mount -o remount,ro /system
