#!/system/xbin/busybox sh

if [ ! -f "/dev/recoverycheck" ]; then

	BUSYBOX=/system/xbin/busybox

	echo 255 > /sys/class/leds/led:rgb_green/brightness

	echo 200 > /sys/class/timed_output/vibrator/enable

	${BUSYBOX} cat /dev/input/event11 > /dev/keycheck&
	${BUSYBOX} sleep 3
	${BUSYBOX} pkill -f "${BUSYBOX} cat"

	if [ -s /dev/keycheck -o -e /cache/recovery/boot ]; then

		# remount rootfs rw
		${BUSYBOX} mount -o remount,rw rootfs /

		${BUSYBOX} cp /system/xbin/busybox /sbin/busybox
		${BUSYBOX} chmod 755 /sbin/busybox

		BUSYBOX=/sbin/busybox

		${BUSYBOX} cp /system/bin/recovery.sh /sbin/recovery.sh
		${BUSYBOX} chmod 755 /sbin/recovery.sh

		exec /sbin/recovery.sh

	fi

	echo 0 > /sys/class/leds/led:rgb_green/brightness

	/sbin/busybox touch /dev/recoverycheck

fi

/system/bin/e2fsck.bin $*
