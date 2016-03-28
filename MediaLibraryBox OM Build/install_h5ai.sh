#!/bin/sh
#
clear
echo "-------------------"
echo "_h5ai Installer"
echo "-------------------"
echo "Unzipping Install Folder"
tar -xvf h5ai_installer.tar
cd h5ai_installer/
echo "Installing h5ai"
cp -fr _h5ai /opt/piratebox/www/
echo "Modifying support files"
cp -f mime.types /opt/piratebox/conf/lighttpd/
cp -f lighttpd.conf /opt/piratebox/conf/lighttpd/
echo "Modifying banner and chat_init.txt"
cp -f banner_Updated /etc/banner
cp -f chat_init.txt /opt/piratebox/conf/chat_init.txt
echo "Select 'A' if prompted to overwrite"
echo "Installation complete - cleaning up temp files"
cd ..
rm -rf h5ai_installer
echo "checking for need of Brand update"
if [ -f /mnt/usb/Brand_Update/install.txt.done ]; then
	mv -f /mnt/usb/Brand_Update/install.txt.done /mnt/usb/Brand_Update/install.txt
	echo "Will do Brand Update in outlying shell"
fi
echo "--------------------------"
echo "= Finished h5ai install  ="
echo "--------------------------"
