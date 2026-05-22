#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen belum terpasang. Install dulu: brew install xcodegen"
  exit 1
fi

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild belum terpasang. Jalankan di macOS dengan Xcode."
  exit 1
fi

xcodegen generate

ARCHIVE_PATH=build/HRBCPMobileIOS.xcarchive
EXPORT_PATH=build/IPA
SCHEME=HRBCPMobileIOS

mkdir -p build

xcodebuild archive \
  -project HRBCPMobileIOS.xcodeproj \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_PATH"

xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$PWD/Scripts/ExportOptions.plist"

echo "IPA generated at $EXPORT_PATH"
