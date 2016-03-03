#!/bin/bash

if [ $# != 1 ]; then
	echo "ERROR: You must provide the rootfs dir from the running build as" >&2
	echo "       an argument to this script" >&2
	exit 1
fi

ROOTFS_DIR="$1"

if [ ! -d "$ROOTFS_DIR" ]; then
	echo "ERROR: The argument provided is not a directory!" >&2
	echo "       $ROOTFS_DIR" >&2
	exit 1
fi

# Copy a new banner image into the buid
cp banner ~/imagebuilder/openwrt-image-build/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/build_dir/target-mips_r2_uClibc-0.9.33.2/root-ar71xx/etc/banner


cd $ROOTFS_DIR

if [ ! -f etc/rc.local ]; then
	echo "ERROR: Can't find ./etc/rc.local inside:" >&2
	echo "       $ROOTFS_DIR" >&2
	exit 1
fi

sed -i -e 's|^exit 0|#exit 0|' -e 's|^if.*/mnt/usb/run-on-boot.sh.*||' ./etc/rc.local
echo "if [ -e /mnt/usb/run-on-boot.sh ]; then /bin/sh /mnt/usb/run-on-boot.sh ; fi" >> ./etc/rc.local

sed -i -e 's|^ext_usbmount_options=.*|ext_usbmount_options="utf8,umask=0,noatime,rw"|' ./etc/ext.config
