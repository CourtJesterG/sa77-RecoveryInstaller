#!/data/local/tmp/cwm/sh

echo remount rw /system
mount -o remount rw /system

echo copy recovery.tar to system.
cat /data/local/tmp/cwm/recovery.tar > /system/bin/recovery.tar
chmod 644 /system/bin/recovery.tar

echo copy script to system.
cat /data/local/tmp/cwm/install-recovery.sh > /system/etc/install-recovery.sh
chmod 755 /system/etc/install-recovery.sh

echo copy binary to system.
cat /data/local/tmp/cwm/sa77_recovery > /system/bin/sa77_recovery
chmod 755 /system/bin/sa77_recovery

echo copy recovery script to system.
cat /data/local/tmp/cwm/recovery.sh > /system/bin/recovery.sh
chmod 755 /system/bin/recovery.sh

echo copy sh to system.
cat /data/local/tmp/cwm/sh > /system/xbin/sh
chmod 755 /system/xbin/sh

echo remount ro /system
mount -o remount ro /system
