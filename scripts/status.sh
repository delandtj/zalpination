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
ALPINE_MINIROOTFS="$ALPINE_DIR/alpine-minirootfs-edge-x86_64.tar.gz"
ALPINE_ROOTFS="$ALPINE_DIR/rootfs"
ZINIT_BIN="$BASE_DIR/zinit"
WORK_DIR="$BASE_DIR/work"
OUTPUT_DIR="$BASE_DIR/output"

# Print header
echo "=== Zalpination Project Status ==="
echo

# Check Alpine minirootfs
echo "Alpine minirootfs:"
if [ -f "$ALPINE_MINIROOTFS" ]; then
    echo "  [✓] Downloaded ($(du -h "$ALPINE_MINIROOTFS" | cut -f1))"
else
    echo "  [✗] Not downloaded"
fi

# Check Alpine rootfs
echo "Alpine rootfs:"
if [ -d "$ALPINE_ROOTFS" ]; then
    echo "  [✓] Extracted ($(du -sh "$ALPINE_ROOTFS" | cut -f1))"
    
    # Check if zinit is installed in the rootfs
    if [ -f "$ALPINE_ROOTFS/sbin/zinit" ]; then
        echo "  [✓] Zinit installed"
    else
        echo "  [✗] Zinit not installed"
    fi
    
    # Check if zinit configuration directory exists
    if [ -d "$ALPINE_ROOTFS/etc/zinit" ]; then
        echo "  [✓] Zinit configuration directory exists"
        
        # Count service configurations
        SERVICE_COUNT=$(find "$ALPINE_ROOTFS/etc/zinit" -name "*.yaml" | wc -l)
        echo "  [✓] $SERVICE_COUNT service configurations found"
    else
        echo "  [✗] Zinit configuration directory does not exist"
    fi
else
    echo "  [✗] Not extracted"
fi

# Check zinit binary
echo "Zinit binary:"
if [ -f "$ZINIT_BIN" ]; then
    echo "  [✓] Built ($(du -h "$ZINIT_BIN" | cut -f1))"
else
    echo "  [✗] Not built"
fi

# Check work directory
echo "Work directory:"
if [ -d "$WORK_DIR" ]; then
    echo "  [✓] Exists ($(du -sh "$WORK_DIR" | cut -f1))"
else
    echo "  [✗] Does not exist"
fi

# Check output directory
echo "Output directory:"
if [ -d "$OUTPUT_DIR" ]; then
    echo "  [✓] Exists"
    
    # Check tarball
    if [ -f "$OUTPUT_DIR/alpine-zinit-rootfs.tar.gz" ]; then
        echo "  [✓] Tarball exists ($(du -h "$OUTPUT_DIR/alpine-zinit-rootfs.tar.gz" | cut -f1))"
    else
        echo "  [✗] Tarball does not exist"
    fi
    
    # Check Dockerfile
    if [ -f "$OUTPUT_DIR/Dockerfile" ]; then
        echo "  [✓] Dockerfile exists"
    else
        echo "  [✗] Dockerfile does not exist"
    fi
else
    echo "  [✗] Does not exist"
fi

# Check Docker image
echo "Docker image:"
if command -v docker &> /dev/null; then
    if docker image inspect alpine-zinit &> /dev/null; then
        echo "  [✓] Exists ($(docker image inspect alpine-zinit --format='{{.Size}}' | numfmt --to=iec-i --suffix=B))"
    else
        echo "  [✗] Does not exist"
    fi
else
    echo "  [✗] Docker not installed"
fi

echo
echo "=== End of Status ==="