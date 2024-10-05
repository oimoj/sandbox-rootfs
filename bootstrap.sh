#!/bin/bash

INSTALL_SCRIPT="install.sh"

cd "$(dirname "$0")"

set -e

if [[ "$UID" != "0" ]]; then
    echo "This script must be run with root privileges."
    exit 1
fi

if ! arch-chroot -h >/dev/null 2>&1; then
    echo "You need arch-chroot to run this script."
    echo "Usually it's in the package 'arch-install-scripts'."
    exit 1
fi

if ! debootstrap --version >/dev/null 2>&1; then
    echo "You need debootstrap to run this script."
    exit 1
fi

if [[ "$ROOTFS_PATH" == "" ]]; then
    echo "Please specify the path to put rootfs on with ROOTFS_PATH."
    exit 1
fi

# Set default mirror if MIRROR is not set
if [[ "$MIRROR" == "" ]]; then
    MIRROR="http://mirrors.tuna.tsinghua.edu.cn/ubuntu"
fi

# Set Ubuntu version and codename to 20.04.1 (focal)
UBUNTU_VERSION="20.04.1"
CODENAME="focal"

# Remove existing rootfs and create a new one
rm -rf "$ROOTFS_PATH"
mkdir -p "$ROOTFS_PATH"

# Use debootstrap to create a rootfs for Ubuntu 20.04.1 (focal)
debootstrap --components=main,universe "$CODENAME" "$ROOTFS_PATH" "$MIRROR"

# Copy the install script into the rootfs
cp "$INSTALL_SCRIPT" "$ROOTFS_PATH/root"

# Run the install script in the chroot environment
arch-chroot "$ROOTFS_PATH" "/root/$INSTALL_SCRIPT"

# Clean up the install script after execution
rm "$ROOTFS_PATH/root/$INSTALL_SCRIPT"