#!/system/xbin/busybox sh

if [ -f "/system/bin/mksh" -a ! -f "/system/bin/ash" ]; then
	/system/xbin/busybox ln -s /system/bin/mksh /system/bin/ash
fi

if [ ! -f "/dev/recoverycheck" ]; then

	BUSYBOX=/system/xbin/busybox

	echo 255 > /sys/class/leds/led:rgb_green/brightness

	#echo 255 > /sys/class/leds/led:rgb_blue/brightness

	echo 200 > /sys/class/timed_output/vibrator/enable
	${BUSYBOX} cat /dev/input/event11 > /dev/keycheck&
	${BUSYBOX} sleep 3
	${BUSYBOX} pkill -f "${BUSYBOX} cat"
	if [ -s /dev/keycheck -o -e /cache/recovery/boot ]; then
#	        echo 100 > /sys/class/timed_output/vibrator/enable



		#echo 0 > /sys/class/leds/led:rgb_green/brightness
		#echo 0 > /sys/class/leds/led:rgb_blue/brightness

		#BUSYBOX=/system/xbin/busybox

		# remount rootfs rw
		${BUSYBOX} mount -o remount,rw rootfs /

		${BUSYBOX} cp /system/xbin/busybox /sbin/busybox
		${BUSYBOX} chmod 755 /sbin/busybox

		BUSYBOX=/sbin/busybox

		${BUSYBOX} cp /system/bin/recovery.sh /sbin/recovery.sh
		${BUSYBOX} chmod 755 /sbin/recovery.sh

		exec /sbin/recovery.sh &

		#echo 0 > /sys/class/leds/led:rgb_green/brightness

	fi

	echo 0 > /sys/class/leds/led:rgb_green/brightness

fi

/sbin/busybox touch /dev/recoverycheck



/system/bin/ash -c "$*"


