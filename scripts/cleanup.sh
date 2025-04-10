#!/bin/bash
set -e

# Directory setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
WORK_DIR="$BASE_DIR/work"
ZINIT_BIN="$BASE_DIR/zinit"

# Ask for confirmation
echo "This script will clean up the project by removing:"
echo "- The work directory (where zinit is built)"
echo "- The zinit binary"
echo "It will NOT remove the Alpine minirootfs or the modified rootfs."
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

# Remove work directory
if [ -d "$WORK_DIR" ]; then
    echo "Removing work directory..."
    rm -rf "$WORK_DIR"
fi

# Remove zinit binary
if [ -f "$ZINIT_BIN" ]; then
    echo "Removing zinit binary..."
    rm -f "$ZINIT_BIN"
fi

echo "Cleanup completed!"