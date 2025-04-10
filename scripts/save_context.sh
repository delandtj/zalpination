#!/bin/bash
set -e

# Directory setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
CONTEXT_FILE="$BASE_DIR/zalpination_context.txt"

echo "Saving project context to $CONTEXT_FILE..."

# Create a header
cat > "$CONTEXT_FILE" << EOF
# Zalpination Project Context
# Saved on: $(date)
# ----------------------------------------

EOF

# Save information about the Alpine minirootfs
if [ -f "$BASE_DIR/alpine-zinit/alpine-minirootfs-edge-x86_64.tar.gz" ]; then
    echo "Alpine minirootfs: Downloaded" >> "$CONTEXT_FILE"
    echo "Size: $(du -h "$BASE_DIR/alpine-zinit/alpine-minirootfs-edge-x86_64.tar.gz" | cut -f1)" >> "$CONTEXT_FILE"
else
    echo "Alpine minirootfs: Not downloaded" >> "$CONTEXT_FILE"
fi

# Save information about the Alpine rootfs
if [ -d "$BASE_DIR/alpine-zinit/rootfs" ]; then
    echo "Alpine rootfs: Extracted" >> "$CONTEXT_FILE"
    echo "Size: $(du -sh "$BASE_DIR/alpine-zinit/rootfs" 2>/dev/null | cut -f1)" >> "$CONTEXT_FILE"
    
    # Check if zinit is installed
    if [ -f "$BASE_DIR/alpine-zinit/rootfs/sbin/zinit" ]; then
        echo "Zinit: Installed in /sbin/zinit" >> "$CONTEXT_FILE"
    else
        echo "Zinit: Not installed" >> "$CONTEXT_FILE"
    fi
    
    # Check if zinit configuration directory exists
    if [ -d "$BASE_DIR/alpine-zinit/rootfs/etc/zinit" ]; then
        echo "Zinit configuration: Created" >> "$CONTEXT_FILE"
        echo "Service configurations: $(find "$BASE_DIR/alpine-zinit/rootfs/etc/zinit" -name "*.yaml" | wc -l)" >> "$CONTEXT_FILE"
    else
        echo "Zinit configuration: Not created" >> "$CONTEXT_FILE"
    fi
else
    echo "Alpine rootfs: Not extracted" >> "$CONTEXT_FILE"
fi

# Save information about the zinit binary
if [ -f "$BASE_DIR/zinit" ]; then
    echo "Zinit binary: Built" >> "$CONTEXT_FILE"
    echo "Size: $(du -h "$BASE_DIR/zinit" | cut -f1)" >> "$CONTEXT_FILE"
else
    echo "Zinit binary: Not built" >> "$CONTEXT_FILE"
fi

# Save information about the work directory
if [ -d "$BASE_DIR/work" ]; then
    echo "Work directory: Exists" >> "$CONTEXT_FILE"
    echo "Size: $(du -sh "$BASE_DIR/work" 2>/dev/null | cut -f1)" >> "$CONTEXT_FILE"
else
    echo "Work directory: Does not exist" >> "$CONTEXT_FILE"
fi

# Save information about the output directory
if [ -d "$BASE_DIR/output" ]; then
    echo "Output directory: Exists" >> "$CONTEXT_FILE"
    
    # Check tarball
    if [ -f "$BASE_DIR/output/alpine-zinit-rootfs.tar.gz" ]; then
        echo "Tarball: Created" >> "$CONTEXT_FILE"
        echo "Size: $(du -h "$BASE_DIR/output/alpine-zinit-rootfs.tar.gz" | cut -f1)" >> "$CONTEXT_FILE"
    else
        echo "Tarball: Not created" >> "$CONTEXT_FILE"
    fi
    
    # Check Dockerfile
    if [ -f "$BASE_DIR/output/Dockerfile" ]; then
        echo "Dockerfile: Created" >> "$CONTEXT_FILE"
    else
        echo "Dockerfile: Not created" >> "$CONTEXT_FILE"
    fi
else
    echo "Output directory: Does not exist" >> "$CONTEXT_FILE"
fi

# Save information about the Docker image
if command -v docker &> /dev/null; then
    if docker image inspect alpine-zinit &> /dev/null; then
        echo "Docker image: Created" >> "$CONTEXT_FILE"
        echo "Size: $(docker image inspect alpine-zinit --format='{{.Size}}' | numfmt --to=iec-i --suffix=B)" >> "$CONTEXT_FILE"
    else
        echo "Docker image: Not created" >> "$CONTEXT_FILE"
    fi
else
    echo "Docker: Not installed" >> "$CONTEXT_FILE"
fi

# Save information about the scripts
echo -e "\n# Scripts" >> "$CONTEXT_FILE"
for script in "$SCRIPT_DIR"/*.sh; do
    script_name=$(basename "$script")
    echo "- $script_name: $(head -n 1 "$script" | sed 's/^#!//')" >> "$CONTEXT_FILE"
done

# Save information about the README
if [ -f "$BASE_DIR/README.md" ]; then
    echo -e "\n# README.md" >> "$CONTEXT_FILE"
    echo "Size: $(wc -l "$BASE_DIR/README.md" | cut -d' ' -f1) lines" >> "$CONTEXT_FILE"
fi

echo "Context saved to $CONTEXT_FILE"