#!/bin/bash
set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (sudo)."
    echo "Please run: sudo $0 <rootfs_path>"
    exit 1
fi

# Check if rootfs path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <rootfs_path>"
    exit 1
fi
ROOTFS="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZINIT_BIN="./zinit"
ZINIT_BIN="./zinit"

# Check if zinit binary exists
if [ ! -f "$ZINIT_BIN" ]; then
    echo "Zinit binary not found. Please run build_zinit.sh first."
    exit 1
fi

# Install zinit binary
echo "Installing zinit binary..."
# Install zinit in /sbin next to the original OpenRC init
cp "$ZINIT_BIN" "$ROOTFS/sbin/"
chmod +x "$ROOTFS/sbin/zinit"

# Create zinit configuration directory
echo "Creating zinit configuration directory..."
mkdir -p "$ROOTFS/etc/zinit"

# Create basic service configurations
echo "Creating basic service configurations..."

# mdev service (device manager)
cat > "$ROOTFS/etc/zinit/mdev.yaml" << EOF
exec: "mdev -s"
oneshot: true
EOF

# syslogd service
cat > "$ROOTFS/etc/zinit/syslogd.yaml" << EOF
exec: "/sbin/syslogd -n"
after:
  - mdev
EOF

# networking service
cat > "$ROOTFS/etc/zinit/networking.yaml" << EOF
exec: "/etc/init.d/networking start"
oneshot: true
after:
  - mdev
EOF

# dropbear (SSH) service
cat > "$ROOTFS/etc/zinit/sshd.yaml" << EOF
exec: "/usr/sbin/sshd -D"
after:
  - networking
EOF

# Copy additional service configurations
echo "Copying additional service configurations..."
cp "$SCRIPT_DIR/zinit_services/"*.yaml "$ROOTFS/etc/zinit/"

# Modify inittab to use zinit as PID 1
echo "Modifying inittab to use zinit as PID 1..."
cp "$ROOTFS/etc/inittab" "$ROOTFS/etc/inittab.orig"
cat > "$ROOTFS/etc/inittab" << EOF
# /etc/inittab

::sysinit:/sbin/zinit init
::shutdown:/sbin/zinit shutdown
::ctrlaltdel:/sbin/reboot

# Set up a console on tty1
tty1::respawn:/sbin/getty 38400 tty1
EOF

echo "Zinit installation complete!"