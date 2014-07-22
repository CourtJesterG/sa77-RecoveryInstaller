#!/system/xbin/busybox sh

if [ ! -f /dev/recoverycheck ]; then

# set variable paths
BUSYBOX=/system/xbin/busybox
VIB=/sys/class/timed_output/vibrator/enable
G_LED=/sys/class/leds/led:rgb_green/brightness
B_LED=/sys/class/leds/led:rgb_blue/brightness
R_LED=/sys/class/leds/led:rgb_red/brightness
EVENT=/dev/input/event11

# remount rootfs rw
${BUSYBOX} mount -o remount,rw rootfs /

# Trigger Cyan LED
echo 255 > ${G_LED}
echo 255 > ${B_LED}

# start keycheck process
${BUSYBOX} cat ${EVENT} > /dev/keycheck&
${BUSYBOX} sleep 1

# kill keycheck process 
${BUSYBOX} pkill -f "${BUSYBOX} cat"

if [ -s /dev/keycheck ]; then

                # turn off LED 
                echo 0 > ${G_LED}
                echo 0 > ${B_LED}

                # cp everything to /sbin
		${BUSYBOX} cp /system/xbin/busybox /sbin/busybox
		${BUSYBOX} chmod 755 /sbin/busybox
		${BUSYBOX} cp /system/bin/recovery.sh /sbin/recovery.sh
		${BUSYBOX} chmod 755 /sbin/recovery.sh
                ${BUSYBOX} cp /system/bin/recovery.tar /sbin/
		BUSYBOX=/sbin/busybox

                # trigger vibrator
	        echo 100 > ${VIB}
                # lower cpu0 frequency
                echo 918000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
                # lower gpu clock
                echo 192000000 >  /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/max_gpuclk

                # exec recovery.sh
		exec /sbin/recovery.sh

fi

# turn off LED
echo 0 > ${G_LED}
echo 0 > ${B_LED}

${BUSYBOX} touch /dev/recoverycheck

fi

# Continue exec e2fsck
/system/bin/e2fsck.bin $*
