#!/sbin/busybox sh

export PATH=/sbin:/system/xbin:/system/bin

BUSYBOX="/sbin/busybox"

${BUSYBOX} mount -o remount,rw rootfs /
${BUSYBOX} rm /cache/recovery/boot
${BUSYBOX} cp /system/bin/recovery.tar /sbin/

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
#${BUSYBOX} umount -l /dev/block/mmcblk0p6
## /boot/modem_fs2
#${BUSYBOX} umount -l /dev/block/mmcblk0p7
## /system
${BUSYBOX} umount -l /dev/block/mmcblk0p28
## /data
${BUSYBOX} umount -l /dev/block/mmcblk0p31
## /mnt/idd
#${BUSYBOX} umount -l /dev/block/mmcblk0p10
## /cache
${BUSYBOX} umount -l /dev/block/mmcblk0p30
## /lta-label
#${BUSYBOX} umount -l /dev/block/mmcblk0p12
## /sdcard (External)
#${BUSYBOX} umount -l /dev/block/mmcblk1p1

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
${BUSYBOX} umount -l /sdcard		# SDCard
${BUSYBOX} umount -l /storage/sdcard	# SDCard
${BUSYBOX} umount -l /storage/sdcard1	# SDCard1
${BUSYBOX} umount -l /cache		# Cache
${BUSYBOX} umount -l /system		# System

${BUSYBOX} sync

cd /
${BUSYBOX} rm -rf etc init* uevent* default* sdcard
${BUSYBOX} tar xf /sbin/recovery.tar

# Execute recovery INIT
${BUSYBOX} chroot / /init
