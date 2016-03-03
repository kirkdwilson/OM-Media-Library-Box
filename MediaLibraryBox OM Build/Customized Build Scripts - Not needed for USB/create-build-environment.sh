#!/bin/bash

IB_DIR="$HOME/imagebuilder"

# Create the build directory
mkdir -p $IB_DIR

# Check out the necessary code
cd $IB_DIR
git clone https://github.com/LibraryBox-Dev/LibraryBox-core.git
git clone https://github.com/PirateBox-Dev/openwrt-image-build.git

# Build the LibraryBox-core image which is used later by the OpenWRT build
cd $IB_DIR/LibraryBox-core/
make shortimage

# Download the imagebuilder images and other various necessary bits
cd $IB_DIR/openwrt-image-build/
git checkout AA-with-installer
cp ../LibraryBox-core/librarybox_2.1_img.tar.gz .
make imagebuilder
