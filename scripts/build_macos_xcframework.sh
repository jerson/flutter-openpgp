#!/usr/bin/env bash
#######################################################
# Wraps the prebuilt macOS Go bridge dynamic library  #
# (macos/libopenpgp_bridge.dylib) into an xcframework #
# so Swift Package Manager can embed and code-sign it #
# into the host app bundle.                           #
#                                                     #
# Requires macOS with Xcode (uses xcodebuild and      #
# install_name_tool). Run after upgrade_bridge_libs   #
# or whenever the dylib changes; commit the result.   #
#                                                     #
# Usage:                                              #
#   ./scripts/build_macos_xcframework.sh              #
#######################################################
set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
  echo "This script must run on macOS (requires xcodebuild)." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MACOS_DIR="$ROOT_DIR/macos"
DYLIB="$MACOS_DIR/libopenpgp_bridge.dylib"
HEADER="$MACOS_DIR/libopenpgp_bridge.h"
# Must sit inside the SwiftPM package dir: Flutter copies the package into an
# ephemeral .packages/ location at build time, so the binaryTarget path has to be
# package-relative (no '..').
OUTPUT="$MACOS_DIR/openpgp/OpenPGPBridge.xcframework"

if [ ! -f "$DYLIB" ]; then
  echo "Missing $DYLIB (run scripts/upgrade_bridge_libs.sh first)." >&2
  exit 1
fi

WORK_DIR="$(mktemp -d)"
HEADERS_DIR="$WORK_DIR/Headers"
trap 'rm -rf "$WORK_DIR"' EXIT
mkdir -p "$HEADERS_DIR"

# Work on a copy so the committed dylib used by CocoaPods stays untouched.
cp "$DYLIB" "$WORK_DIR/libopenpgp_bridge.dylib"

# Ensure the install name is rpath-relative so SPM's embedded copy is found at
# launch and DynamicLibrary.open('libopenpgp_bridge.dylib') resolves the loaded
# image by its leaf name (matches the CocoaPods @loader_path/../Frameworks setup).
install_name_tool -id "@rpath/libopenpgp_bridge.dylib" "$WORK_DIR/libopenpgp_bridge.dylib"

# Stage the header plus a module map so Swift sees an `OpenPGPBridge` module.
cp "$HEADER" "$HEADERS_DIR/"
cat > "$HEADERS_DIR/module.modulemap" <<'EOF'
module OpenPGPBridge {
    header "libopenpgp_bridge.h"
    export *
}
EOF

rm -rf "$OUTPUT"
xcodebuild -create-xcframework \
  -library "$WORK_DIR/libopenpgp_bridge.dylib" \
  -headers "$HEADERS_DIR" \
  -output "$OUTPUT"

echo "Created $OUTPUT"
