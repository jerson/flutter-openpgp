#!/usr/bin/env bash
#######################################################
# Build PQC-capable native bridge libraries from      #
# the openpgp-mobile Go source with PQC additions.    #
#                                                     #
# Prerequisites:                                      #
#   - Go 1.21+                                        #
#   - Android NDK (for Android targets)               #
#   - Xcode (for iOS/macOS targets, macOS only)       #
#   - EMSCRIPTEN SDK (for WASM target)                #
#                                                     #
# Usage:                                              #
#   ./scripts/build_native.sh                         #
#######################################################

set -euo pipefail

REPO="https://github.com/jerson/openpgp-mobile.git"
WORK_DIR=$(mktemp -d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
NATIVE_DIR="$PROJECT_DIR/native"

echo "Cloning openpgp-mobile..."
git clone --depth=1 "$REPO" "$WORK_DIR/openpgp-mobile"
cd "$WORK_DIR/openpgp-mobile"

echo "Applying PQC go.mod dependencies..."
go get github.com/ProtonMail/go-crypto@v1.1.3
go get github.com/cloudflare/circl@v1.3.7

echo "Copying PQC bridge additions..."
# Copy into bridge/ subdirectory (package bridge).
# If openpgp-mobile uses a flat package main layout, copy to the module root instead.
BRIDGE_PKG_DIR="$WORK_DIR/openpgp-mobile/bridge"
[ -d "$BRIDGE_PKG_DIR" ] || BRIDGE_PKG_DIR="$WORK_DIR/openpgp-mobile"
# Remove the build-ignore tag so Go compiles the file in its new location.
sed '/^\/\/go:build ignore/d; /^\/\/ +build ignore/d' \
    "$NATIVE_DIR/openpgp_pqc.go" > "$BRIDGE_PKG_DIR/openpgp_pqc.go"

echo "Patching algorithm dispatch in bridge/openpgp.go..."
# The patch inserts PQC cases into the existing algorithm switch statement.
# If openpgp-mobile changes its source layout, update the sed pattern below.
python3 - <<'PYEOF'
import re, sys

with open("bridge/openpgp.go", "r") as f:
    src = f.read()

# Locate the generate function's algorithm mapping block and append PQC cases.
pqc_cases = """
\t\tcase 6, 7, 8, 9: // PQC algorithms (MLDSA65ED25519 / MLDSA87ED448 / MLKEM768X25519 / MLKEM1024X448)
\t\t\tpqcEntity, pqcErr := GeneratePQCKeyPair(name, comment, email, passphrase, int32(keyOptions.Algorithm), defaultHash)
\t\t\tif pqcErr != nil {
\t\t\t\treturn nil, pqcErr
\t\t\t}
\t\t\tif pqcEntity != nil {
\t\t\t\treturn pqcEntity, nil
\t\t\t}"""

# Insert before the closing brace of the existing algorithm switch.
# Matches "default:" or "}" that ends the switch on algorithm.
patched = re.sub(
    r'(\t\tdefault:)',
    pqc_cases + r'\n\t\t\1',
    src,
    count=1
)

if patched == src:
    print("WARNING: Could not auto-patch bridge/openpgp.go – apply PQC cases manually.", file=sys.stderr)
    sys.exit(0)

with open("bridge/openpgp.go", "w") as f:
    f.write(patched)

print("Patched bridge/openpgp.go successfully.")
PYEOF

echo "Running go mod tidy..."
go mod tidy

echo "Building for current platform (host)..."
go build ./...

# ── Android ──────────────────────────────────────────────────────────────────
if command -v $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/*/bin/aarch64-linux-android21-clang &>/dev/null 2>&1 || [ -n "${ANDROID_NDK_HOME:-}" ]; then
  echo "Building Android arm64-v8a..."
  GOOS=android GOARCH=arm64 CGO_ENABLED=1 \
    CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang" \
    go build -buildmode=c-shared -o "$PROJECT_DIR/android/src/main/jniLibs/arm64-v8a/libopenpgp_bridge.so" .

  echo "Building Android armeabi-v7a..."
  GOOS=android GOARCH=arm GOARM=7 CGO_ENABLED=1 \
    CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi21-clang" \
    go build -buildmode=c-shared -o "$PROJECT_DIR/android/src/main/jniLibs/armeabi-v7a/libopenpgp_bridge.so" .

  echo "Building Android x86_64..."
  GOOS=android GOARCH=amd64 CGO_ENABLED=1 \
    CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android21-clang" \
    go build -buildmode=c-shared -o "$PROJECT_DIR/android/src/main/jniLibs/x86_64/libopenpgp_bridge.so" .

  echo "Building Android x86..."
  GOOS=android GOARCH=386 CGO_ENABLED=1 \
    CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/i686-linux-android21-clang" \
    go build -buildmode=c-shared -o "$PROJECT_DIR/android/src/main/jniLibs/x86/libopenpgp_bridge.so" .
else
  echo "Skipping Android (ANDROID_NDK_HOME not set)."
fi

# ── Linux ─────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "linux"* ]]; then
  echo "Building Linux x86_64..."
  GOOS=linux GOARCH=amd64 CGO_ENABLED=1 \
    go build -buildmode=c-shared -o "$PROJECT_DIR/linux/shared/x86_64/libopenpgp_bridge.so" .

  if command -v aarch64-linux-gnu-gcc &>/dev/null; then
    echo "Building Linux aarch64..."
    GOOS=linux GOARCH=arm64 CGO_ENABLED=1 \
      CC=aarch64-linux-gnu-gcc \
      go build -buildmode=c-shared -o "$PROJECT_DIR/linux/shared/aarch64/libopenpgp_bridge.so" .
  else
    echo "Skipping Linux aarch64 (aarch64-linux-gnu-gcc not found)."
  fi
fi

# ── macOS / iOS ───────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building macOS arm64+x86_64 universal dylib..."
  GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 \
    go build -buildmode=c-shared -o /tmp/libopenpgp_bridge_arm64.dylib .
  GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 \
    go build -buildmode=c-shared -o /tmp/libopenpgp_bridge_amd64.dylib .
  lipo -create /tmp/libopenpgp_bridge_arm64.dylib /tmp/libopenpgp_bridge_amd64.dylib \
    -output "$PROJECT_DIR/macos/libopenpgp_bridge.dylib"
  echo "macOS universal dylib built."

  echo "Note: iOS xcframework build requires xcodebuild and gomobile."
  echo "  gomobile bind -target=ios github.com/jerson/openpgp-mobile/bridge"
fi

# ── Windows ───────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || [[ "$OSTYPE" == "win"* ]]; then
  echo "Building Windows x86_64 DLL..."
  GOOS=windows GOARCH=amd64 CGO_ENABLED=1 \
    go build -buildmode=c-shared -o "$PROJECT_DIR/windows/shared/libopenpgp_bridge.dll" .
fi

echo "────────────────────────────────────────────"
echo "PQC-capable native bridge build complete."
echo "Tip: run 'make upgrade' only to refresh non-PQC libs from upstream releases;"
echo "     for PQC support always use 'make build-native' to compile from source."

rm -rf "$WORK_DIR"
