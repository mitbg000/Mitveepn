#!/bin/bash
# Fix script for building FlClash core with space in path

set -e

echo "================================================"
echo "Fix Build Script for Mitveepn Client"
echo "================================================"
echo ""

# Get project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Project directory: $PROJECT_DIR"
echo ""

# Check if we're in the right directory
if [ ! -f "setup.dart" ]; then
    echo "❌ Error: setup.dart not found. Please run this script from project root."
    exit 1
fi

echo "Step 1: Building Clash Meta core for macOS..."
echo ""

# Build core manually
cd core

echo "Installing Go dependencies..."
export GOPROXY=https://proxy.golang.org,direct
go mod download

echo ""
echo "Building MitveepnCore for macOS ARM64..."
export CGO_ENABLED=1
export GOOS=darwin
export GOARCH=arm64

# Build the library
go build -buildmode=c-shared -o libclash.dylib -trimpath -ldflags="-w -s" .

if [ ! -f "libclash.dylib" ]; then
    echo "❌ Failed to build libclash.dylib"
    exit 1
fi

echo "✅ libclash.dylib built successfully"
echo ""

# Create libclash directory structure
cd ..
mkdir -p libclash/macos

# Copy the built library
cp core/libclash.dylib libclash/macos/MitveepnCore

echo "✅ MitveepnCore copied to libclash/macos/"
echo ""

echo "Step 2: Verifying build..."
if [ -f "libclash/macos/MitveepnCore" ]; then
    echo "✅ MitveepnCore exists at: libclash/macos/MitveepnCore"
    ls -lh libclash/macos/MitveepnCore
else
    echo "❌ MitveepnCore not found"
    exit 1
fi

echo ""
echo "================================================"
echo "✅ Build Complete!"
echo "================================================"
echo ""
echo "You can now run:"
echo "  flutter run"
echo ""
