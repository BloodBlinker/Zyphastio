#!/bin/bash

# F-Droid Build Script for Zyphastio
# Usage: ./build_fdroid.sh [prebuild|build]

set -e

FLUTTER_VERSION="3.10.4"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="${SCRIPT_DIR}/.flutter-sdk"

setup_flutter() {
    if [ ! -d "$FLUTTER_DIR" ]; then
        echo "Downloading Flutter ${FLUTTER_VERSION}..."
        mkdir -p "$FLUTTER_DIR"
        curl -L "$FLUTTER_URL" -o /tmp/flutter.tar.xz
        tar xf /tmp/flutter.tar.xz -C "$FLUTTER_DIR" --strip-components=1
        rm /tmp/flutter.tar.xz
    fi
    
    export PATH="$FLUTTER_DIR/bin:$PATH"
    export PUB_CACHE="${SCRIPT_DIR}/.pub-cache"
    
    flutter config --no-analytics
    flutter doctor -v
}

prebuild() {
    echo "=== PREBUILD PHASE ==="
    setup_flutter
    
    echo "Getting dependencies..."
    flutter pub get
    
    echo "Running code generation (Riverpod/Isar)..."
    flutter pub run build_runner build --delete-conflicting-outputs
    
    echo "Prebuild complete!"
}

build() {
    echo "=== BUILD PHASE ==="
    setup_flutter
    
    echo "Building release APK..."
    flutter build apk --release
    
    echo "Build complete!"
    echo "APK location: build/app/outputs/flutter-apk/app-release.apk"
}

# Main
case "$1" in
    prebuild)
        prebuild
        ;;
    build)
        build
        ;;
    *)
        echo "Usage: $0 [prebuild|build]"
        echo "  prebuild - Download Flutter, get dependencies, run code generation"
        echo "  build    - Build the release APK"
        exit 1
        ;;
esac
