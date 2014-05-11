#!/sbin/busybox sh

exec > /dev/null 2>&1

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
/sbin/busybox mount -o remount,rw /system

#Autoroot Script
if /sbin/busybox [ ! -f /data/local/tmp/root-veng4 ]; 
then
	/sbin/busybox mkdir /system/xbin
	/sbin/busybox chmod 755 /system/xbin

	/sbin/busybox rm /system/bin/su
	/sbin/busybox rm /system/xbin/su
	/sbin/busybox cp /res/autoroot/su /system/xbin/su
	/sbin/busybox chown root.root /system/xbin/su
	/sbin/busybox chmod 06755 /system/xbin/su

	/sbin/busybox rm /system/app/Superuser.apk
	/sbin/busybox rm /data/app/Superuser.apk
	/sbin/busybox cp /res/autoroot/Superuser.apk /system/app/Superuser.apk
	/sbin/busybox chown root.root /system/app/Superuser.apk
	/sbin/busybox chmod 0644 /system/app/Superuser.apk

	if /sbin/busybox [ ! -f /system/xbin/busybox ]; 
	then	
		if /sbin/busybox [ ! -f /system/bin/busybox ]; 
		then	
			/sbin/busybox cp /sbin/busybox /system/xbin/busybox
			/sbin/busybox chown root.root /system/xbin/busybox
			/sbin/busybox chmod 4777 /system/xbin/busybox
			/system/xbin/busybox --install -s /system/xbin/
		fi
	fi
	/sbin/busybox touch /data/local/tmp/root-veng4
fi;

#init.d
/sbin/busybox mkdir -p /system/etc/init.d
/sbin/busybox chown -R root.root /system/etc/init.d
/sbin/busybox chmod -R 0755 /system/etc/init.d
/system/bin/logwrapper /sbin/busybox run-parts /system/etc/init.d
touch /data/local/tmp/sysinit.txt

