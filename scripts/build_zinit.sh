#!/bin/bash
set -e

# Create work directory
mkdir -p work
cd work

# Clone zinit repository
if [ ! -d "zinit" ]; then
    echo "Cloning zinit repository..."
    git clone https://github.com/threefoldtech/zinit.git
    cd zinit
else
    echo "Zinit repository already exists, updating..."
    cd zinit
    git pull
fi

# Build zinit (statically linked with musl)
echo "Building zinit..."
make

# Copy the binary to a known location
echo "Copying zinit binary..."
cp target/x86_64-unknown-linux-musl/release/zinit ../../

echo "Zinit build complete!"