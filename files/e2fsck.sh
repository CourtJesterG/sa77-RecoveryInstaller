#!/system/xbin/busybox sh

if [ ! -f "/dev/recoverycheck" ]; then

	BUSYBOX=/system/xbin/busybox
        VIB=/sys/class/timed_output/vibrator/enable
        G_LED=/sys/class/leds/led:rgb_green/brightness
        B_LED=/sys/class/leds/led:rgb_blue/brightness
        R_LED=/sys/class/leds/led:rgb_red/brightness

	# remount rootfs rw
	${BUSYBOX} mount -o remount,rw rootfs /

	echo 255 > ${G_LED}
        echo 255 > ${B_LED}

	${BUSYBOX} cat /dev/input/event11 > /dev/keycheck&
	${BUSYBOX} sleep 2
	${BUSYBOX} pkill -f "${BUSYBOX} cat"

	if [ -s /dev/keycheck -o -e /cache/recovery/boot ]; then

		${BUSYBOX} cp /system/xbin/busybox /sbin/busybox
		${BUSYBOX} chmod 755 /sbin/busybox

		BUSYBOX=/sbin/busybox

		${BUSYBOX} cp /system/bin/recovery.sh /sbin/recovery.sh
		${BUSYBOX} chmod 755 /sbin/recovery.sh

	        echo 100 > ${VIB}

		exec /sbin/recovery.sh

	fi

	echo 0 > ${G_LED}
	echo 0 > ${B_LED}

	${BUSYBOX} touch /dev/recoverycheck

fi

/system/bin/e2fsck.bin $*
