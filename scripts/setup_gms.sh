#!/bin/bash
# setup_gms.sh - Automated GMS installation helper
# Run on your cloud phone server with ADB connected

set -e

DEVICE="${1:-localhost:5555}"
GAPPS_URL="${2:-https://github.com/nift4/mindthegapps/releases/download/15.0.0/MindTheGapps-15.0.0-arm64.zip}"
GAPPS_ZIP="/tmp/mindthegapps.zip"

echo "=== Cloud Phone GMS Installer ==="
echo "Device: $DEVICE"
echo ""

# Check ADB connection
echo "[1/6] Checking ADB connection..."
adb connect "$DEVICE" || true
if ! adb -s "$DEVICE" shell echo "Connected" > /dev/null 2>&1; then
    echo "ERROR: Cannot connect to device $DEVICE"
    echo "Make sure ADB is enabled on your cloud phone and you can connect."
    exit 1
fi
echo "✓ Connected"

# Download GAPPS
echo "[2/6] Downloading GAPPS package..."
curl -L -o "$GAPPS_ZIP" "$GAPPS_URL" --progress-bar
echo "✓ Downloaded"

# Push to device
echo "[3/6] Pushing to device..."
adb -s "$DEVICE" push "$GAPPS_ZIP" /sdcard/MindTheGapps.zip
echo "✓ Pushed"

# Boot recovery and install
echo "[4/6] Boot into recovery..."
adb -s "$DEVICE" reboot recovery
echo "Waiting 30s for recovery to boot..."
sleep 30
echo "✓ In recovery mode"

echo "[5/6] Flash GAPPS..."
adb -s "$DEVICE" shell "echo 'install /sdcard/MindTheGapps.zip' | toybox cat > /dev/null 2>&1 || echo 'Manual flash required: Install /sdcard/MindTheGapps.zip via TWRP'"
echo "✓ Flash initiated"

echo "[6/6] Rebooting..."
adb -s "$DEVICE" reboot
echo "✓ Rebooting - GMS will be ready after boot"

echo ""
echo "=== Done! ==="
echo "After boot, open Play Store and sign in with your Google account."
echo "Then run 'play-integrity-helper verify' to check integrity status."
echo ""
echo "Need a pre-built cloud phone image? Visit https://www.qtphone.com"
