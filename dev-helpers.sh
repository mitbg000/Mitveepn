# Development Helper Scripts
# Source this file to get useful aliases and functions

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Aliases for common tasks
alias xb-clean='flutter clean && cd lib/sdk/flutter_xboard_sdk && flutter clean && cd ../../..'
alias xb-get='flutter pub get && cd lib/sdk/flutter_xboard_sdk && flutter pub get && cd ../../..'
alias xb-gen='cd lib/sdk/flutter_xboard_sdk && dart run build_runner build --delete-conflicting-outputs && cd ../../..'
alias xb-build-android='dart setup.dart android'
alias xb-build-windows='dart setup.dart windows --arch amd64'
alias xb-build-macos='dart setup.dart macos --arch arm64'
alias xb-build-linux='dart setup.dart linux --arch amd64'
alias xb-run='flutter run'
alias xb-devices='flutter devices'
alias xb-doctor='flutter doctor -v'
alias xb-logs='flutter logs'

# Function to regenerate SDK code
xb-regen() {
    echo -e "${BLUE}Regenerating XBoard SDK code...${NC}"
    cd "$PROJECT_ROOT/lib/sdk/flutter_xboard_sdk"
    flutter clean
    flutter pub get
    dart run build_runner build --delete-conflicting-outputs
    cd "$PROJECT_ROOT"
    echo -e "${GREEN}✅ SDK code regenerated${NC}"
}

# Function to full clean and setup
xb-reset() {
    echo -e "${BLUE}Full project reset...${NC}"
    cd "$PROJECT_ROOT"

    # Clean everything
    flutter clean
    cd lib/sdk/flutter_xboard_sdk
    flutter clean
    cd ../../..

    # Reinstall dependencies
    cd lib/sdk/flutter_xboard_sdk
    flutter pub get
    dart run build_runner build --delete-conflicting-outputs
    cd ../../..

    flutter pub get

    echo -e "${GREEN}✅ Project reset complete${NC}"
}

# Function to check project status
xb-status() {
    echo -e "${BLUE}=== Xboard-Mihomo Client Status ===${NC}"
    echo ""

    # Check Flutter
    if command -v flutter &> /dev/null; then
        echo -e "${GREEN}✅ Flutter: $(flutter --version | head -n 1)${NC}"
    else
        echo -e "${RED}❌ Flutter not found${NC}"
    fi

    # Check Dart
    if command -v dart &> /dev/null; then
        echo -e "${GREEN}✅ Dart: $(dart --version 2>&1 | head -n 1)${NC}"
    else
        echo -e "${RED}❌ Dart not found${NC}"
    fi

    # Check Golang
    if command -v go &> /dev/null; then
        echo -e "${GREEN}✅ Golang: $(go version)${NC}"
    else
        echo -e "${YELLOW}⚠️  Golang not found (needed for building Clash core)${NC}"
    fi

    echo ""

    # Check submodules
    echo -e "${BLUE}Submodules:${NC}"
    git submodule status

    echo ""

    # Check config files
    echo -e "${BLUE}Configuration Files:${NC}"
    if [ -f "config.json" ]; then
        echo -e "${GREEN}✅ config.json${NC}"
    else
        echo -e "${RED}❌ config.json (missing)${NC}"
    fi

    if [ -f "assets/config/xboard.config.yaml" ]; then
        echo -e "${GREEN}✅ xboard.config.yaml${NC}"
    else
        echo -e "${RED}❌ xboard.config.yaml (missing)${NC}"
    fi

    echo ""

    # Check SDK generated code
    if [ -f "lib/sdk/flutter_xboard_sdk/lib/src/models/user_info.g.dart" ]; then
        echo -e "${GREEN}✅ SDK code generated${NC}"
    else
        echo -e "${YELLOW}⚠️  SDK code not generated (run xb-gen)${NC}"
    fi
}

# Function to open config files
xb-config() {
    if [ "$1" = "client" ]; then
        ${EDITOR:-nano} assets/config/xboard.config.yaml
    elif [ "$1" = "backend" ]; then
        ${EDITOR:-nano} config.json
    else
        echo "Usage: xb-config [client|backend]"
        echo "  client  - Edit assets/config/xboard.config.yaml"
        echo "  backend - Edit config.json"
    fi
}

# Function to tail logs
xb-tail() {
    echo -e "${BLUE}Tailing Flutter logs... (Ctrl+C to stop)${NC}"
    flutter logs
}

# Function to run on specific device
xb-run-on() {
    if [ -z "$1" ]; then
        echo "Available devices:"
        flutter devices
        echo ""
        echo "Usage: xb-run-on <device-id>"
    else
        flutter run -d "$1"
    fi
}

# Function to build for all platforms
xb-build-all() {
    echo -e "${BLUE}Building for all platforms...${NC}"

    echo -e "${YELLOW}Building Android...${NC}"
    dart setup.dart android

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${YELLOW}Building macOS...${NC}"
        dart setup.dart macos --arch arm64
    fi

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo -e "${YELLOW}Building Linux...${NC}"
        dart setup.dart linux --arch amd64
    fi

    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo -e "${YELLOW}Building Windows...${NC}"
        dart setup.dart windows --arch amd64
    fi

    echo -e "${GREEN}✅ All builds complete${NC}"
}

# Function to show help
xb-help() {
    echo -e "${BLUE}=== Xboard-Mihomo Development Helper ===${NC}"
    echo ""
    echo "Aliases:"
    echo "  xb-clean          - Clean Flutter build cache"
    echo "  xb-get            - Get dependencies"
    echo "  xb-gen            - Generate SDK code"
    echo "  xb-build-android  - Build Android APK"
    echo "  xb-build-windows  - Build Windows EXE"
    echo "  xb-build-macos    - Build macOS APP"
    echo "  xb-build-linux    - Build Linux binary"
    echo "  xb-run            - Run on default device"
    echo "  xb-devices        - List available devices"
    echo "  xb-doctor         - Run Flutter doctor"
    echo "  xb-logs           - Show Flutter logs"
    echo ""
    echo "Functions:"
    echo "  xb-regen          - Regenerate SDK code"
    echo "  xb-reset          - Full clean and setup"
    echo "  xb-status         - Check project status"
    echo "  xb-config <type>  - Edit config (client|backend)"
    echo "  xb-tail           - Tail Flutter logs"
    echo "  xb-run-on <id>    - Run on specific device"
    echo "  xb-build-all      - Build for all platforms"
    echo "  xb-help           - Show this help"
    echo ""
}

echo -e "${GREEN}Xboard-Mihomo development helpers loaded!${NC}"
echo -e "Run ${BLUE}xb-help${NC} to see available commands"
