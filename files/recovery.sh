#!/sbin/busybox sh

export PATH=/sbin:/system/xbin:/system/bin

BUSYBOX="/sbin/busybox"

REDLED=$(/sbin/busybox ls -1 /sys/class/leds|/sbin/busybox grep "red\|LED1_R")
GREENLED=$(/sbin/busybox ls -1 /sys/class/leds|/sbin/busybox grep "green\|LED1_G")
BLUELED=$(/sbin/busybox ls -1 /sys/class/leds|/sbin/busybox grep "blue\|LED1_B")

SETLED() {

        BRIGHTNESS_LED_RED="/sys/class/leds/$REDLED/brightness"
        CURRENT_LED_RED="/sys/class/leds/$REDLED/led_current"
        BRIGHTNESS_LED_GREEN="/sys/class/leds/$GREENLED/brightness"
        CURRENT_LED_GREEN="/sys/class/leds/$GREENLED/led_current"
        BRIGHTNESS_LED_BLUE="/sys/class/leds/$BLUELED/brightness"
        CURRENT_LED_BLUE="/sys/class/leds/$BLUELED/led_current"

        if [ "$1" = "on" ]; then

                echo "$2" > ${BRIGHTNESS_LED_RED}
                echo "$3" > ${BRIGHTNESS_LED_GREEN}
                echo "$4" > ${BRIGHTNESS_LED_BLUE}

                if [ -f "$CURRENT_LED_RED" -a -f "$CURRENT_LED_GREEN" -a -f "$CURRENT_LED_BLUE" ]; then

                        echo "$2" > ${CURRENT_LED_RED}
                        echo "$3" > ${CURRENT_LED_GREEN}
                        echo "$4" > ${CURRENT_LED_BLUE}
                fi

        else

                echo "0" > ${BRIGHTNESS_LED_RED}
                echo "0" > ${BRIGHTNESS_LED_GREEN}
                echo "0" > ${BRIGHTNESS_LED_BLUE}

                if [ -f "$CURRENT_LED_RED" -a -f "$CURRENT_LED_GREEN" -a -f "$CURRENT_LED_BLUE" ]; then

                        echo "0" > ${CURRENT_LED_RED}
                        echo "0" > ${CURRENT_LED_GREEN}
                        echo "0" > ${CURRENT_LED_BLUE}
                fi

        fi
}

${BUSYBOX} mount -o remount,rw rootfs /
${BUSYBOX} rm /cache/recovery/boot
${BUSYBOX} cp /system/bin/recovery.tar /sbin/

SETLED on 255 255 0

# Stop init services.
for SVCNAME in $(getprop | ${BUSYBOX} grep -E '^\[init\.svc\..*\]: \[running\]' | ${BUSYBOX} sed 's/\[init\.svc\.\(.*\)\]:.*/\1/g;'); do
	if [ "${SVCNAME}" != "" -a "${SVCNAME}" != "adbd" ]; then
		stop ${SVCNAME}
	fi
done

# Preemptive strike against locking applications
for LOCKINGPID in `${BUSYBOX} lsof | ${BUSYBOX} awk '{print $1" "$2}' | ${BUSYBOX} grep "/sbin\|/bin\|/system\|/data\|/cache" | ${BUSYBOX} grep -v "adbd\|recovery.sh\|busybox" | ${BUSYBOX} awk '{print $1}'`; do
	BINARY=$(${BUSYBOX} cat /proc/${LOCKINGPID}/status | ${BUSYBOX} grep -i "name" | ${BUSYBOX} awk -F':\t' '{print $2}')
	if [ "$BINARY" != "" ]; then
		${BUSYBOX} killall $BINARY
	fi
done

${BUSYBOX} sync

## /boot/modem_fs1
${BUSYBOX} umount -l /dev/block/mmcblk0p6
## /boot/modem_fs2
${BUSYBOX} umount -l /dev/block/mmcblk0p7
## /system
${BUSYBOX} umount -l /dev/block/mmcblk0p13
## /data
${BUSYBOX} umount -l /dev/block/mmcblk0p15
## /mnt/idd
${BUSYBOX} umount -l /dev/block/mmcblk0p10
## /cache
${BUSYBOX} umount -l /dev/block/mmcblk0p14
## /lta-label
${BUSYBOX} umount -l /dev/block/mmcblk0p12
## /sdcard (External)
${BUSYBOX} umount -l /dev/block/mmcblk1p1

${BUSYBOX} umount -l /acct
${BUSYBOX} umount -l /dev/cpuctl
${BUSYBOX} umount -l /dev/pts
${BUSYBOX} umount -l /mnt/int_storage
${BUSYBOX} umount -l /mnt/asec
${BUSYBOX} umount -l /mnt/obb
${BUSYBOX} umount -l /mnt/qcks
${BUSYBOX} umount -l /mnt/idd		# Appslog
${BUSYBOX} umount -l /data/idd		# Appslog
${BUSYBOX} umount -l /data		# Userdata
${BUSYBOX} umount -l /lta-label		# LTALabel
${BUSYBOX} umount -l /storage/sdcard1	# SDCard1
${BUSYBOX} umount -l /cache		# Cache
${BUSYBOX} umount -l /system		# System

${BUSYBOX} sync

cd /
${BUSYBOX} rm -rf etc init* uevent* default*
${BUSYBOX} tar xf /sbin/recovery.tar

${BUSYBOX} sleep 1
SETLED off

# Execute recovery INIT
${BUSYBOX} chroot / /init
