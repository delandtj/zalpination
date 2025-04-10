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
ROOTFS_DIR="$BASE_DIR/rootfs"
ALPINE_ROOTFS="$BASE_DIR/alpine-zinit/rootfs"
ALPINE_MINIROOTFS="$BASE_DIR/alpine-zinit/alpine-minirootfs-3.19.1-x86_64.tar.gz"

# Check dependencies
echo "Checking dependencies..."
"$SCRIPT_DIR/check_dependencies.sh"

# Download Alpine minirootfs if it doesn't exist
echo "Checking Alpine minirootfs..."
"$SCRIPT_DIR/download_alpine.sh"

# Build zinit
echo "Building zinit..."
cd "$BASE_DIR"
"$SCRIPT_DIR/build_zinit.sh"

# Install zinit in the rootfs
echo "Installing zinit in the rootfs..."
"$SCRIPT_DIR/install_zinit.sh" "$ALPINE_ROOTFS"

echo "Alpine with zinit as PID 1 has been created successfully!"
echo "The modified rootfs is located at: $ALPINE_ROOTFS"