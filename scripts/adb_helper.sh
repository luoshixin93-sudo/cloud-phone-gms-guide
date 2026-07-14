#!/bin/bash
# adb_helper.sh - ADB convenience script for cloud phone management

DEVICE="${1:-localhost:5555}"
ACTION="${2:-status}"

connect_to_cloud_phone() {
    echo "Connecting to cloud phone at $DEVICE..."
    adb connect "$DEVICE"
}

show_device_info() {
    echo "=== Device Info ==="
    adb -s "$DEVICE" shell getprop ro.product.model
    adb -s "$DEVICE" shell getprop ro.build.version.release
    adb -s "$DEVICE" shell getprop ro.build.version.security_patch
    echo "=== Storage ==="
    adb -s "$DEVICE" shell df -h /data
}

check_gms() {
    echo "=== GMS Status ==="
    if adb -s "$DEVICE" shell pm list packages | grep -q "com.android.vending"; then
        echo "✓ Google Play Store: INSTALLED"
    else
        echo "✗ Google Play Store: NOT FOUND"
    fi
    
    if adb -s "$DEVICE" shell pm list packages | grep -q "com.google.android.gms"; then
        echo "✓ Google Play Services: INSTALLED"
    else
        echo "✗ Google Play Services: NOT FOUND"
    fi
}

clear_google_cache() {
    echo "Clearing Google Play cache..."
    adb -s "$DEVICE" shell pm clear com.google.android.gms
    adb -s "$DEVICE" shell pm clear com.android.vending
    echo "✓ Cache cleared"
}

reboot_device() {
    echo "Rebooting device..."
    adb -s "$DEVICE" reboot
}

case "$ACTION" in
    connect) connect_to_cloud_phone ;;
    info) show_device_info ;;
    gms) check_gms ;;
    clear) clear_google_cache ;;
    reboot) reboot_device ;;
    *) 
        echo "Usage: $0 <device-ip:port> <action>"
        echo "Actions: connect | info | gms | clear | reboot"
        ;;
esac
