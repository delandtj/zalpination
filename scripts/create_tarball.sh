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
ALPINE_ROOTFS="$ALPINE_DIR/rootfs"
OUTPUT_DIR="$BASE_DIR/output"
OUTPUT_FILE="$OUTPUT_DIR/alpine-zinit-rootfs.tar.gz"

# Check if rootfs directory exists
if [ ! -d "$ALPINE_ROOTFS" ]; then
    echo "Alpine rootfs directory not found at $ALPINE_ROOTFS"
    echo "Please run create_alpine_zinit.sh first."
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Create tarball
echo "Creating tarball of the modified rootfs..."
tar -czf "$OUTPUT_FILE" -C "$ALPINE_DIR" rootfs

echo "Tarball created at $OUTPUT_FILE"