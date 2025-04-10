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
DOCKERFILE="$OUTPUT_DIR/Dockerfile"

# Check if rootfs directory exists
if [ ! -d "$ALPINE_ROOTFS" ]; then
    echo "Alpine rootfs directory not found at $ALPINE_ROOTFS"
    echo "Please run create_alpine_zinit.sh first."
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install it first."
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Create Dockerfile
echo "Creating Dockerfile..."
cat > "$DOCKERFILE" << EOF
FROM scratch
ADD rootfs /
CMD ["/sbin/zinit", "init"]
EOF

# Create Docker image
echo "Creating Docker image..."
cd "$ALPINE_DIR"
docker build -t alpine-zinit -f "$DOCKERFILE" .

echo "Docker image 'alpine-zinit' created successfully!"
echo "You can run it using: docker run -it --device=/dev/kmsg:/dev/kmsg:rw alpine-zinit"