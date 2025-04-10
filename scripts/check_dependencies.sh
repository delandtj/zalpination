#!/bin/bash
set -e

# Check for required dependencies
echo "Checking for required dependencies..."

# Git
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install it first."
    exit 1
fi
echo "✓ git is installed"

# Rust/Cargo
if ! command -v cargo &> /dev/null; then
    echo "Error: cargo is not installed. Please install Rust first."
    echo "You can install Rust using: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi
echo "✓ cargo is installed"

# Make
if ! command -v make &> /dev/null; then
    echo "Error: make is not installed. Please install it first."
    exit 1
fi
echo "✓ make is installed"

# musl-gcc
if ! command -v musl-gcc &> /dev/null; then
    echo "Warning: musl-gcc is not installed. This might cause issues when building zinit."
    echo "On Debian/Ubuntu, you can install it using: sudo apt install musl musl-tools"
    echo "On Fedora, you can install it using: sudo dnf install musl musl-devel"
    echo "On Alpine Linux, musl is already the default libc."
fi

# systemd-nspawn (optional)
if ! command -v systemd-nspawn &> /dev/null; then
    echo "Warning: systemd-nspawn is not installed. You won't be able to run the container."
    echo "On Debian/Ubuntu, you can install it using: sudo apt install systemd-container"
fi

echo "All required dependencies are installed!"