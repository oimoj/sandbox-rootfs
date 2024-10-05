#!/bin/bash -e

GCC_VERSION="9.3.0"
UBUNTU_CODENAME="$(source /etc/os-release && echo "$UBUNTU_CODENAME")"

# Fix PATH environment variable
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Set Locale
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
export LC_ALL=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' > /etc/default/locale

# Create sandbox user and directories
useradd -r sandbox -d /sandbox -m
mkdir -p /sandbox/{binary,source,working}

# Add ubuntu-updates source
ORIGINAL_SOURCE=$(head -n 1 /etc/apt/sources.list)
sed "s/$UBUNTU_CODENAME/$UBUNTU_CODENAME-updates/" <<< "$ORIGINAL_SOURCE" >> /etc/apt/sources.list

# Install dependencies
apt-get update
apt-get dist-upgrade -y
apt-get install -y gnupg ca-certificates curl wget locales unzip zip git

# Install g++ 9.3.0
apt-get install -y g++-9 gcc-9

# Create symlinks for g++ 9.3.0
ln -s /usr/bin/g++-9 /usr/local/bin/g++
ln -s /usr/bin/gcc-9 /usr/local/bin/gcc

# Install standard testlib
git clone https://github.com/MikeMirzayanov/testlib /tmp/testlib
cp /tmp/testlib/testlib.h /usr/include/

# Clean the APT cache
apt-get clean