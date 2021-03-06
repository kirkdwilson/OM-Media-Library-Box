#!/bin/bash

IB_DIR="$HOME/imagebuilder"
OIB_DIR="$IB_DIR/openwrt-image-build"

cd $OIB_DIR

# Insert unzip into GENERAL_PACKAGES
sed -i 's/GENERAL_PACKAGES:=pbxopkg box-installer/GENERAL_PACKAGES:=unzip pbxopkg box-installer/' Makefile

make imagebuilder
if [ $? != 0 ]; then
	echo "ERROR: Issue during build.  Stopping build script." >&2
	exit 1
fi

# Apply the pause-before-tarring-rootfs patch, if necessary
PATCH_FILE="OM-pause-before-tarring-rootfs.patch"
cat > $PATCH_FILE << 'EOF'
--- OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/include/image.mk.old	2016-02-11 13:20:34.145864595 -0600
+++ OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/include/image.mk	2016-02-11 13:20:16.694865635 -0600
@@ -115,6 +115,13 @@
 ifneq ($(CONFIG_TARGET_ROOTFS_TARGZ),)
   define Image/mkfs/targz
 		# Preserve permissions (-p) when building as non-root user
+		#
+		# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
+		# Going to pause now just before tarring up the rootfs.
+		# Make mods to the rootfs now, then when you're done, press <Enter>
+		# The directory contain the rootfs is:
+		# $(TARGET_DIR)
+		read
 		$(TAR) -czpf $(BIN_DIR)/$(IMG_PREFIX)-rootfs.tar.gz --numeric-owner --owner=0 --group=0 -C $(TARGET_DIR)/ .
   endef
 endif
EOF
patch -p0 < $PATCH_FILE

make MR3040 INSTALL_TARGET=librarybox
if [ $? != 0 ]; then
	echo "ERROR: Issue during build MR3040.  Stopping build script." >&2
	exit 1
fi

make MR13U INSTALL_TARGET=librarybox
if [ $? != 0 ]; then
	echo "ERROR: Issue during build MR13U. Stopping build script." >&2
	exit 1
fi

make install_zip INSTALL_TARGET=librarybox
if [ $? != 0 ]; then
	echo "ERROR: Issue during build librarybox. Stopping build script." >&2
	exit 2
fi

echo ""
echo "Build finished.  Output files located in:"
echo "$OIB_DIR/target_librarybox/"
