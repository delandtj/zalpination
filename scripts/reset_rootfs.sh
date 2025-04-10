#!/bin/bash
set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (sudo)."
    echo "Please run: sudo $0"
    exit 1
fi

# Directory setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
ALPINE_DIR="$BASE_DIR/alpine-zinit"
ALPINE_MINIROOTFS="$ALPINE_DIR/alpine-minirootfs-3.19.1-x86_64.tar.gz"
ALPINE_ROOTFS="$ALPINE_DIR/rootfs"

# Check if Alpine minirootfs exists
if [ ! -f "$ALPINE_MINIROOTFS" ]; then
    echo "Alpine minirootfs not found at $ALPINE_MINIROOTFS"
    echo "Please download it first using download_alpine.sh"
    exit 1
fi

# Ask for confirmation
echo "This script will reset the rootfs to its original state (without zinit)."
echo "All changes made to the rootfs will be lost."
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Reset cancelled."
    exit 0
fi

# Remove the rootfs directory
if [ -d "$ALPINE_ROOTFS" ]; then
    echo "Removing rootfs directory..."
    rm -rf "$ALPINE_ROOTFS"
fi

# Extract the minirootfs again
echo "Extracting Alpine minirootfs..."
mkdir -p "$ALPINE_ROOTFS"
tar -xzf "$ALPINE_MINIROOTFS" -C "$ALPINE_ROOTFS"

echo "Rootfs has been reset to its original state!"