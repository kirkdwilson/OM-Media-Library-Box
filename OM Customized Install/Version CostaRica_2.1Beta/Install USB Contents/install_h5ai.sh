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
echo "Modifying files"
cp -f mime.types /opt/piratebox/conf/lighttpd/
cp -f lighttpd.conf /opt/piratebox/conf/lighttpd/
echo "Select 'A' if prompted to overwrite"
echo "Installation complete - cleaning up temp files"
cd ..
rm -rf h5ai_installer
echo "--------------------------"
echo "= Finished h5ai install  ="
echo "--------------------------"
