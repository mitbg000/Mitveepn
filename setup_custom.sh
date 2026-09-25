#!/bin/bash

# Custom Setup Script for Xboard-Mihomo Client
# This script helps you set up the project with your custom configuration

set -e

echo "=================================="
echo "Xboard-Mihomo Client Setup"
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed. Please install Flutter first.${NC}"
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo -e "${RED}❌ Dart is not installed. Please install Dart first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter and Dart are installed${NC}"
echo ""

# Step 1: Initialize submodules
echo "Step 1: Initializing Git submodules..."
if git submodule update --init --recursive; then
    echo -e "${GREEN}✅ Submodules initialized successfully${NC}"
else
    echo -e "${RED}❌ Failed to initialize submodules${NC}"
    exit 1
fi
echo ""

# Step 2: Generate SDK code
echo "Step 2: Generating XBoard SDK code..."
cd lib/sdk/flutter_xboard_sdk

if flutter pub get; then
    echo -e "${GREEN}✅ SDK dependencies installed${NC}"
else
    echo -e "${RED}❌ Failed to install SDK dependencies${NC}"
    exit 1
fi

if dart run build_runner build --delete-conflicting-outputs; then
    echo -e "${GREEN}✅ SDK code generated successfully${NC}"
else
    echo -e "${RED}❌ Failed to generate SDK code${NC}"
    exit 1
fi

cd ../../..
echo ""

# Step 3: Install project dependencies
echo "Step 3: Installing project dependencies..."
if flutter pub get; then
    echo -e "${GREEN}✅ Project dependencies installed${NC}"
else
    echo -e "${RED}❌ Failed to install project dependencies${NC}"
    exit 1
fi
echo ""

# Step 4: Check configuration files
echo "Step 4: Checking configuration files..."
CONFIG_NEEDED=false

if [ ! -f "config.json" ]; then
    echo -e "${YELLOW}⚠️  config.json not found${NC}"
    echo "   Please create config.json from config.example.json"
    CONFIG_NEEDED=true
fi

if [ ! -f "assets/config/xboard.config.yaml" ]; then
    echo -e "${YELLOW}⚠️  xboard.config.yaml not found${NC}"
    echo "   Please create xboard.config.yaml from xboard.config.example.yaml"
    CONFIG_NEEDED=true
fi

if [ "$CONFIG_NEEDED" = true ]; then
    echo ""
    echo -e "${YELLOW}Configuration files are missing. Create them now? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        if [ ! -f "config.json" ]; then
            cp config.example.json config.json
            echo -e "${GREEN}✅ Created config.json (please edit it with your settings)${NC}"
        fi
        if [ ! -f "assets/config/xboard.config.yaml" ]; then
            cp assets/config/xboard.config.example.yaml assets/config/xboard.config.yaml
            echo -e "${GREEN}✅ Created xboard.config.yaml (please edit it with your settings)${NC}"
        fi
    fi
fi
echo ""

# Step 5: Summary
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Edit config.json with your backend URLs"
echo "2. Edit assets/config/xboard.config.yaml with your settings"
echo "3. Upload config.json to your hosting (GitHub/Gitee/CDN)"
echo "4. Update the remote_config.sources[0].url in xboard.config.yaml"
echo "5. Build the app:"
echo "   - Android: dart setup.dart android"
echo "   - Windows: dart setup.dart windows --arch amd64"
echo "   - macOS:   dart setup.dart macos --arch arm64"
echo "   - Linux:   dart setup.dart linux --arch amd64"
echo ""
echo "For development:"
echo "   flutter run -d <device-id>"
echo ""
echo "Documentation: See CUSTOMIZATION_GUIDE.md"
echo ""
