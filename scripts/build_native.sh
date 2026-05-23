#!/usr/bin/env bash
#######################################################
# Build PQC-capable native bridge libraries from      #
# native/ (the self-contained Go module in this repo) #
#                                                     #
# Prerequisites:                                      #
#   - Go 1.25+                                        #
#   - gcc (for CGO)                                   #
#   - Android NDK (ANDROID_NDK_HOME) for Android      #
#   - Xcode + gomobile for iOS (macOS only)           #
#   - aarch64-linux-gnu-gcc for Linux aarch64         #
#                                                     #
# Usage:                                              #
#   ./scripts/build_native.sh                         #
#######################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
NATIVE_DIR="$PROJECT_DIR/native"

cd "$NATIVE_DIR"

# ── Linux ─────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "linux"* ]]; then
  echo "Building Linux x86_64..."
  GOOS=linux GOARCH=amd64 CGO_ENABLED=1 \
    go build -buildmode=c-shared \
    -o "$PROJECT_DIR/linux/shared/x86_64/libopenpgp_bridge.so" .

  if command -v aarch64-linux-gnu-gcc &>/dev/null; then
    echo "Building Linux aarch64..."
    GOOS=linux GOARCH=arm64 CGO_ENABLED=1 \
      CC=aarch64-linux-gnu-gcc \
      go build -buildmode=c-shared \
      -o "$PROJECT_DIR/linux/shared/aarch64/libopenpgp_bridge.so" .
  else
    echo "Skipping Linux aarch64 (aarch64-linux-gnu-gcc not found)."
  fi
fi

# ── macOS ─────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building macOS arm64..."
  GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 \
    go build -buildmode=c-shared \
    -o /tmp/libopenpgp_bridge_arm64.dylib .

  echo "Building macOS x86_64..."
  GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 \
    go build -buildmode=c-shared \
    -o /tmp/libopenpgp_bridge_amd64.dylib .

  echo "Creating macOS universal dylib..."
  lipo -create \
    /tmp/libopenpgp_bridge_arm64.dylib \
    /tmp/libopenpgp_bridge_amd64.dylib \
    -output "$PROJECT_DIR/macos/libopenpgp_bridge.dylib"
  echo "macOS universal dylib built."
fi

# ── Android ───────────────────────────────────────────────────────────────────
if [ -n "${ANDROID_NDK_HOME:-}" ]; then
  PREBUILT="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin"

  echo "Building Android arm64-v8a..."
  GOOS=android GOARCH=arm64 CGO_ENABLED=1 \
    CC="$PREBUILT/aarch64-linux-android21-clang" \
    go build -buildmode=c-shared \
    -o "$PROJECT_DIR/android/src/main/jniLibs/arm64-v8a/libopenpgp_bridge.so" .

  echo "Building Android armeabi-v7a..."
  GOOS=android GOARCH=arm GOARM=7 CGO_ENABLED=1 \
    CC="$PREBUILT/armv7a-linux-androideabi21-clang" \
    go build -buildmode=c-shared \
    -o "$PROJECT_DIR/android/src/main/jniLibs/armeabi-v7a/libopenpgp_bridge.so" .

  echo "Building Android x86_64..."
  GOOS=android GOARCH=amd64 CGO_ENABLED=1 \
    CC="$PREBUILT/x86_64-linux-android21-clang" \
    go build -buildmode=c-shared \
    -o "$PROJECT_DIR/android/src/main/jniLibs/x86_64/libopenpgp_bridge.so" .

  echo "Building Android x86..."
  GOOS=android GOARCH=386 CGO_ENABLED=1 \
    CC="$PREBUILT/i686-linux-android21-clang" \
    go build -buildmode=c-shared \
    -o "$PROJECT_DIR/android/src/main/jniLibs/x86/libopenpgp_bridge.so" .
else
  echo "Skipping Android (ANDROID_NDK_HOME not set)."
fi

# ── Windows ───────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || [[ "$OSTYPE" == "win"* ]]; then
  echo "Building Windows x86_64 DLL..."
  GOOS=windows GOARCH=amd64 CGO_ENABLED=1 \
    go build -buildmode=c-shared \
    -o "$PROJECT_DIR/windows/shared/libopenpgp_bridge.dll" .
fi

echo "────────────────────────────────────────────"
echo "PQC-capable native bridge build complete."
echo ""
echo "iOS: requires gomobile — run from macOS:"
echo "  cd native && gomobile bind -target=ios -o ../ios/OpenPGPBridge.xcframework ."
echo ""
echo "WASM: not supported via CGO. Requires a separate pure-Go build path."
