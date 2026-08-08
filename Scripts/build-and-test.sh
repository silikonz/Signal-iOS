#!/usr/bin/env zsh

LOG_DIR="$HOME/Library/Logs/Signal-CI"
rm -rf "$LOG_DIR"
mkdir -p "$LOG_DIR"

SCHEMA_DIR="$HOME/Library/Signal-iOS-Schema"
rm -rf "$SCHEMA_DIR"
mkdir -p "$SCHEMA_DIR"

./Scripts/feature_flags_internal.py

echo
set -o pipefail \
&& NSUnbufferedIO=YES xcodebuild \
  -workspace Signal.xcworkspace \
  -scheme Signal \
  -configuration "App Store Release" \
  -destination 'platform=macOS,arch=arm64,variant=Designed for iPad' \
  SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD=YES \
  CODE_SIGNING_ALLOWED=YES \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="-" \
  AD_HOC_CODE_SIGNING_ALLOWED=YES \
  CODE_SIGN_STYLE="Manual" \
  DEVELOPMENT_TEAM="" \
  PROVISIONING_PROFILE_SPECIFIER="" \
  -disableAutomaticPackageResolution \
  -derivedDataPath ./build \
  build \
  2>&1 \
| tee "$LOG_DIR/Signal-CI.log" \
| xcbeautify \
  --renderer github-actions \
  --disable-logging \
| while IFS= read -r line; do
  printf '[%s] %s\n' "$(date +%H:%M:%S)" "$line"
done

XCODEBUILD_RESULT_CODE=$?

PRODUCTS_DIR="$HOME/Library/Signal-iOS-Products"
mv ./build/Build/Products/ "$PRODUCTS_DIR"

exit $XCODEBUILD_RESULT_CODE
