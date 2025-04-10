#!/bin/bash
set -e

# Directory setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
ALPINE_ROOTFS="$BASE_DIR/alpine-zinit/rootfs"

# Check if rootfs directory exists
if [ ! -d "$ALPINE_ROOTFS" ]; then
    echo "Alpine rootfs directory not found at $ALPINE_ROOTFS"
    exit 1
fi

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (sudo)."
    echo "Please run: sudo $0"
    exit 1
fi

# Mount necessary filesystems
echo "Mounting necessary filesystems..."
mount -t proc none "$ALPINE_ROOTFS/proc"
mount -t sysfs none "$ALPINE_ROOTFS/sys"
mount -o bind /dev "$ALPINE_ROOTFS/dev"

# Chroot into the rootfs and test zinit
echo "Chrooting into the rootfs and testing zinit..."
chroot "$ALPINE_ROOTFS" /sbin/zinit --version
chroot "$ALPINE_ROOTFS" /sbin/zinit list

# Unmount filesystems
echo "Unmounting filesystems..."
umount "$ALPINE_ROOTFS/dev"
umount "$ALPINE_ROOTFS/sys"
umount "$ALPINE_ROOTFS/proc"

echo "Test completed successfully!"