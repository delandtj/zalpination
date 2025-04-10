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

# Check if systemd-nspawn is available
if ! command -v systemd-nspawn &> /dev/null; then
    echo "systemd-nspawn is not installed. Please install it first."
    exit 1
fi

# Run the container
echo "Running the container with zinit as PID 1..."
systemd-nspawn \
    --directory="$ALPINE_ROOTFS" \
    --capability=all \
    --bind=/dev/kmsg:/dev/kmsg:rw \
    --boot

echo "Container stopped."