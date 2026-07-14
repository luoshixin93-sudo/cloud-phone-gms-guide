# cloud-phone-gms-guide

📱 **Complete Guide to Install Google Play Store & GMS on Cloud Phones**

> The English version of [ggaz](https://github.com/vben98192/ggaz) — adapted for cloud phone environments and international users.

Running Android apps on a cloud phone? Need Google Play Store, Play Services, and Google framework? This guide covers every method that actually works on cloud infrastructure.

**[Deploy a cloud phone with pre-installed GMS → qtphone.com](https://www.qtphone.com)**

[![GitHub stars](https://img.shields.io/github/stars/luoshixin93-sudo/cloud-phone-gms-guide)](https://github.com/luoshixin93-sudo/cloud-phone-gms-guide)
[![English](https://img.shields.io/badge/Language-English-blue.svg)](README.md)
[![Last updated](https://img.shields.io/badge/Updated-July%202026-brightgreen)](https://github.com/luoshixin93-sudo/cloud-phone-gms-guide/commits)

---

## Table of Contents

- [Why This Guide?](#why-this-guide)
- [Prerequisites](#prerequisites)
- [Method 1: Pre-built GMS Images (Recommended)](#method-1-pre-built-gms-images-recommended)
- [Method 2: Via Magisk + GAPPS Package](#method-2-via-magisk--gapps-package)
- [Method 3: MicroG (Open Source Alternative)](#method-3-microg-open-source-alternative)
- [Method 4: Manual APK Installation](#method-4-manual-apk-installation)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Which Method Should You Use?](#which-method-should-you-use)

---

## Why This Guide?

Most cloud phones come without Google Mobile Services (GMS) pre-installed. This means:

- ❌ Google Play Store is missing
- ❌ Apps that depend on Google Play Services won't work (YouTube, Gmail, banking apps)
- ❌ Google SafetyNet / Play Integrity checks fail

This guide provides **working solutions** for installing GMS on cloud Android devices, covering both **rooted** and **non-rooted** approaches.

---

## Prerequisites

- An Android cloud phone (physical or virtual) running Android 7.0 or higher
- ADB tools installed on your computer
- A computer to run ADB commands
- Optional: Root access (Magisk recommended)

### Install ADB

**macOS:**
```bash
brew install android-platform-tools
```

**Linux:**
```bash
sudo apt install adb  # Debian/Ubuntu
sudo pacman -S android-tools  # Arch
```

**Windows:**
Download from [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools).

Verify installation:
```bash
adb version
```

### Connect to Your Cloud Phone

```bash
# Enable ADB over WiFi on your cloud phone, then:
adb connect <cloud-phone-ip>:5555

# Example:
adb connect 192.168.1.100:5555

# Verify connection:
adb devices
```

---

## Method 1: Pre-built GMS Images (Recommended) ⭐

**Best for:** Users who want the easiest, most reliable solution.

The fastest way to get Play Store working on a cloud phone is to use a custom ROM or image that already includes GMS.

### Option 1A: Qtphone.com Pre-built Images

> [qtphone.com](https://www.qtphone.com) offers cloud phones with GMS pre-installed and optimized for cloud deployment.

Advantages:
- ✅ Pre-configured, works out of the box
- ✅ Regular security updates
- ✅ Compatible with Play Integrity checks
- ✅ Managed by professionals

### Option 1B: OpenGApps

Download OpenGApps from [opengapps.org](https://opengapps.org/) and flash via recovery:

1. Download the correct variant for your Android version:
   - **stock** = closest to factory image
   - **super** = everything included
   - **nano** = minimal, recommended for cloud phones

2. Flash via TWRP:
```bash
adb push open_gapps-arm64-14.0-stock-*.zip /sdcard/
adb shell twrp install /sdcard/open_gapps-arm64-14.0-stock-*.zip
adb reboot
```

---

## Method 2: Via Magisk + GAPPS Package ⭐

**Best for:** Rooted cloud phones running Magisk.

This method gives you the most control and best compatibility with Play Integrity checks.

### Step 1: Install Magisk

If you don't have Magisk installed:

1. Download Magisk Manager from [github.com/topjohnwu/Magisk](https://github.com/topjohnwu/Magisk)
2. Patch your boot image
3. Flash via recovery

### Step 2: Install Zygisk

```bash
# In Magisk Manager:
# Settings → Zygisk → Enable
```

### Step 3: Install PlayIntegrityFix Module

This is crucial for passing Google Play Integrity checks after installing GMS:

1. Download [PlayIntegrityFix](https://github.com/chiteroman/PlayIntegrityFix/releases/latest) (ZIP)
2. Flash in Magisk Manager → Modules → Install from storage
3. Or via ADB:
```bash
adb install PlayIntegrityFix-v*.zip
```

### Step 4: Download GAPPS Package

Choose one:

| Package | Size | Best For |
|---------|------|----------|
| [OpenGApps](https://opengapps.org/) | Variable | Stock Google experience |
| [MindTheGapps](https://github.com/nift4/mindthegapps) | ~200MB | Clean, minimal |
| [BitGApps](https://github.com/nicholasio/BitGApps) | ~150MB | ARM64 only |

```bash
# Example: Download MindTheGapps
wget https://github.com/nift4/mindthegapps/releases/download/15.0.0/MindTheGapps-15.0.0-arm64.zip
adb push MindTheGapps-15.0.0-arm64.zip /sdcard/
```

### Step 5: Flash GAPPS via Recovery

```bash
# Boot into recovery
adb reboot recovery

# In TWRP:
# Install → Select MindTheGapps-*.zip → Swipe to flash
# Wipe → Dalvik Cache (optional but recommended)

# Reboot
adb reboot
```

### Step 6: Post-Installation Setup

```bash
# After boot, grant permissions
adb shell pm grant com.google.android.gms android.permission.ACCESS_FINE_LOCATION
adb shell pm grant com.google.android.gsf android.permission.READ_PHONE_STATE

# Clear Play Store cache
adb shell pm clear com.android.vending
adb shell pm clear com.google.android.gms
```

---

## Method 3: MicroG (Open Source Alternative) ⭐

**Best for:** Privacy-conscious users, degoogled ROMs, or when you can't use Google services.

[MicroG](https://microg.org/) is an open-source reimplementation of Google Play Services. It provides:

- ✅ Google Play Store (via microG's store client or your own APK)
- ✅ Maps API (replacement)
- ✅ Location services
- ✅ Push notifications (via FCM)
- ✅ Fully open source

### Installation

1. Download MicroG from [microg.org/download.html](https://microg.org/download.html)
2. Install via ADB:
```bash
adb install com.mgoogle.gms-*.apk
```

### Signature Spoofing (Required)

MicroG requires signature spoofing to work. On compatible ROMs this is built-in. On others, use:
- [FakeGApps](https://github.com/nift4/FakeGApps) Xposed module
- Or a ROM with built-in signature spoofing support (like [LineageOS for microG](https://lineageos4microg.github.io/))

---

## Method 4: Manual APK Installation

**Best for:** Non-rooted cloud phones, testing purposes.

This method doesn't require root but has limitations:
- Some apps may detect the unofficial installation
- Google Play Protect may flag apps
- No background services

### Required APKs

Download from APKMirror or similar trusted sources:

1. **Google Play Store** ( vending.apk / SetupWizard equivalent)
2. **Google Services Framework** ( gsf.apk)
3. **Google Play Services** ( gms.apk)

### Installation Steps

```bash
# Enable installation from unknown sources
adb shell settings put global install_non_market_apps 1

# Install each APK in order
adb install -r GoogleServicesFramework.apk
adb install -r com.google.android.gms.apk
adb install -r com.android.vending.apk

# Restart
adb shell svc power reboot
```

---

## Verification

After installation, verify everything works:

### 1. Check Play Store

```bash
adb shell am start -n com.android.vending/com.google.android.finsky.aa
```

### 2. Check Play Integrity Status

Use [YASNAC](https://github.com/RikkaApps/YASNAC) or our companion tool:

```bash
pip install play-integrity-helper
play-integrity-helper check --device <your-device-ip>:5555
```

You should see:
- ✅ **Device Integrity**: PASS
- ✅ **Basic Integrity**: PASS
- ✅ **CTS Profile Match**: PASS

### 3. Download an App

Try downloading a simple app from Play Store to confirm full functionality.

---

## Troubleshooting

### Problem: "Device not certified" in Play Store

**Cause:** Google doesn't recognize your device.

**Fix:**
```bash
# Register your device fingerprint with Google
# This requires your device's GAID (Google Advertising ID)
# Check with an app like "Device ID" from Play Store

# Alternative: Use a custom ROM with GMS pre-certified
# → [qtphone.com](https://www.qtphone.com) offers certified images
```

### Problem: Apps crash after installing GMS

**Fix:**
```bash
# Clear all data for affected apps
adb shell pm clear com.google.android.gms
adb shell pm clear com.android.vending

# Re-open Play Store and sign in
```

### Problem: Play Integrity still fails

**Fix:**
1. Make sure PlayIntegrityFix module is installed and enabled
2. Clear Play Services data: `adb shell pm clear com.google.android.gms`
3. Wait 5 minutes (Google caches integrity verdicts)
4. Check again

### Problem: ADB connection drops

**Fix:**
```bash
# Set a static ADB port
adb tcpip 5555

# Reconnect
adb connect <device-ip>:5555

# Keep-alive (run in background on your server)
while true; do adb connect <device-ip>:5555; sleep 30; done
```

---

## Which Method Should You Use?

| Method | Root Required | Difficulty | Reliability | GMS Certified |
|--------|--------------|------------|-------------|----------------|
| **Qtphone Pre-built** | No | ⭐ Easy | ⭐⭐⭐⭐⭐ | ✅ Yes |
| **Magisk + GAPPS** | Yes | ⭐⭐⭐ Medium | ⭐⭐⭐⭐ | ⚠️ Manual |
| **MicroG** | Optional | ⭐⭐ Medium | ⭐⭐⭐ | ❌ Partial |
| **Manual APK** | No | ⭐⭐⭐ Medium | ⭐⭐ | ❌ No |

> 💡 **Recommendation:** For production cloud phone deployments, use **qtphone.com pre-built images** for the best compatibility with Play Integrity checks and app stability.

---

## References

This guide is inspired by and extends the original [ggaz](https://github.com/vben98192/ggaz) project (Chinese), adapted for:
- English-speaking cloud phone operators
- Cloud infrastructure environments
- Integration with PlayIntegrityFix

Related Projects:
- [PlayIntegrityFix](https://github.com/chiteroman/PlayIntegrityFix)
- [Universal SafetyNet Fix](https://github.com/kdrag0n/safetynet-fix)
- [OpenGApps](https://opengapps.org/)
- [MicroG](https://microg.org/)
- [MindTheGapps](https://github.com/nift4/mindthegapps)

---

## Contributing

Found an issue or have a better method? Open an Issue or Pull Request!

---

## License

MIT License - Free to use, share, and modify.

---

## Cloud Phone Infrastructure

Need a reliable cloud phone platform that works with Google Play out of the box?

👉 **[qtphone.com](https://www.qtphone.com)** — Android cloud phones in the cloud, accessible from anywhere.

- Pre-installed GMS options available
- ADB access included
- Scales from 1 to 1000+ devices
