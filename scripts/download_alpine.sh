#!/bin/bash
set -e

# Directory setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
ALPINE_DIR="$BASE_DIR/alpine-zinit"
ALPINE_MINIROOTFS="$ALPINE_DIR/alpine-minirootfs-3.19.1-x86_64.tar.gz"
ALPINE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.1-x86_64.tar.gz"

# Create alpine-zinit directory if it doesn't exist
mkdir -p "$ALPINE_DIR"

# Check if Alpine minirootfs exists
if [ -f "$ALPINE_MINIROOTFS" ]; then
    echo "Alpine minirootfs already exists at $ALPINE_MINIROOTFS"
else
    echo "Downloading Alpine minirootfs..."
    if command -v wget &> /dev/null; then
        wget -O "$ALPINE_MINIROOTFS" "$ALPINE_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$ALPINE_MINIROOTFS" "$ALPINE_URL"
    else
        echo "Error: Neither wget nor curl is installed. Please install one of them first."
        exit 1
    fi
    echo "Download completed!"
fi

# Check if rootfs directory exists
if [ -d "$ALPINE_DIR/rootfs" ]; then
    echo "Alpine rootfs directory already exists at $ALPINE_DIR/rootfs"
else
    echo "Extracting Alpine minirootfs..."
    mkdir -p "$ALPINE_DIR/rootfs"
    tar -xzf "$ALPINE_MINIROOTFS" -C "$ALPINE_DIR/rootfs"
    echo "Extraction completed!"
fi

echo "Alpine minirootfs is ready!"