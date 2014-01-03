#!/system/xbin/sh

echo 255 > /sys/class/leds/led:rgb_green/brightness
echo 255 > /sys/class/leds/led:rgb_blue/brightness

cat /dev/input/event11 > /dev/keycheck&
sleep 3
kill -9 $!
if [ -s /dev/keycheck -o -e /cache/recovery/boot ]; then
	echo 100 > /sys/class/timed_output/vibrator/enable
	reboot recovery
fi

echo 0 > /sys/class/leds/led:rgb_green/brightness
echo 0 > /sys/class/leds/led:rgb_blue/brightness

