#!/bin/sh

LED_EXTENDROOT=/sys/class/leds/*wlan
LED_PACKAGE_1=/sys/class/leds/*3g
LED_PACKAGE_2=/sys/class/leds/*lan
NEEDREBOOT=0

_signaling_start(){
	for file in  $1 ; do echo "timer" > $file/trigger ; done
	return 0
}

_signaling_stop(){
	for file in  $1 ; do echo "none" > $file/trigger ; done
	for file in  $1 ; do echo "1" > $file/brightness ; done
	return 0
}

# Log all script output to a file
exec >> /mnt/usb/run-on-boot.log
exec 2>&1

echo ""
echo "##########################################################"
echo "Run-On-Boot Script: `date`"
cd /mnt/usb

set -x

if [ -e /mnt/usb/install/auto_package ]; then
	# LibraryBox hasn't configured itself yet
	# Wait for the next boot
	exit 0
fi

#Switch 3G/LAN -light online, that Run-On-Boot is executing
	_signaling_start  "$LED_PACKAGE_1"
	_signaling_start  "$LED_PACKAGE_2"
	
	
# Install h5ai
if [ -f /mnt/usb/install_h5ai.sh ]; then
	chmod a+x /mnt/usb/install_h5ai.sh
	sh /mnt/usb/install_h5ai.sh
	mv /mnt/usb/install_h5ai.sh /mnt/usb/install_h5ai.sh.done
	NEEDREBOOT=1

fi
# Install Web Brand Update if it exsists
if [ -f /mnt/usb/Brand_Update/install.txt ]; then
	cp -rf /mnt/usb/Brand_Update/* /mnt/usb/LibraryBox/Content/
	rm /mnt/usb/LibraryBox/Content/install.txt
	mv /mnt/usb/Brand_Update/install.txt /mnt/usb/Brand_Update/install.txt.done
	NEEDREBOOT=1
fi

# Install Config Update if it exsists
if [ -f /mnt/usb/Config_Update/install.txt ]; then
	cp -rf /mnt/usb/Config_Update/* /mnt/usb/LibraryBox/Config/
	rm /mnt/usb/LibraryBox/Config/install.txt
	mv /mnt/usb/Config_Update/install.txt /mnt/usb/Config_Update/install.txt.done
	NEEDREBOOT=1
fi

#Switch 3G/LAN -light online, that Run-On-Boot is Finished
	_signaling_stop  "$LED_PACKAGE_1"
	_signaling_stop  "$LED_PACKAGE_2"


# Check for reboot required
if [ $NEEDREBOOT = 1 ] ; then
	echo "rebooting after configuration changes"
	sync && reboot
else
	echo "no reboot needed"
fi
