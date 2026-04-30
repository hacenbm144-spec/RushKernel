# RushKernel Installation Guide

## Before you start

### Required state
- **Device:** Samsung Galaxy S22 Ultra Exynos (SM-S908B / codename `b0s`)
- **Bootloader:** Unlocked (Knox tripped — this is permanent)
- **Custom recovery:** TWRP or OrangeFox installed for b0s
- **Patched vbmeta:** Already flashed (comes with most custom ROMs)

If you're not sure about any of these, **stop and check first.**

### Backup checklist
1. ✅ TWRP backup of current `boot` partition (so you can restore if RushKernel doesn't work for you)
2. ✅ Smart Switch backup of personal data (just in case)
3. ✅ Note your current ROM version (so you can re-flash if needed)
4. ✅ Stock firmware downloaded on PC (recovery option of last resort)

---

## Installation steps

### 1. Download

Get the latest release from: https://github.com/hacenbm144-spec/RushKernel/releases

You want the file named `RushKernel-vX.X.X-b0s-YYYYMMDD.zip`.

Verify the SHA256 hash matches the `.sha256` file (optional but recommended).

### 2. Transfer to phone

Copy the zip to your phone's internal storage. Easiest paths:
- USB cable → drag-and-drop to `Download` folder
- Google Drive → download on phone
- Direct download from GitHub on phone

### 3. Boot to recovery

Power off your phone, then:
1. Hold **Volume Down + Power** until screen goes black
2. Immediately switch to **Volume Up + Power** to enter recovery

### 4. (Optional but strongly recommended) Backup boot

In TWRP:
- **Backup** → check only `Boot` → swipe to confirm
- Note where the backup is saved (usually `TWRP/BACKUPS/...`)
- Copy to PC via MTP for safety

### 5. Install RushKernel

In TWRP:
- **Install** → navigate to where you saved the zip
- Select `RushKernel-vX.X.X-b0s-*.zip`
- **Swipe to confirm flash**

The flash takes about 10-30 seconds.

### 6. Reboot

- **Reboot** → **System**
- First boot may take 1-2 minutes longer than usual (kernel cache rebuild)

---

## Verifying the install

After reboot, open **Termux** (or any terminal app):

```bash
uname -r
```

You should see `5.10.x-RushKernel-...` in the output.

To verify BBR is active:

```bash
sysctl net.ipv4.tcp_congestion_control
```

Should output: `net.ipv4.tcp_congestion_control = bbr`

To verify available congestion algorithms:

```bash
sysctl net.ipv4.tcp_available_congestion_control
```

Should include `bbr` in the list.

---

## Troubleshooting

### "Bootloop after flashing"

1. Boot to TWRP (Volume Up + Power from off state)
2. **Restore** → select your boot backup → check only `Boot` → swipe
3. Reboot — you'll be back on your previous kernel

If you don't have a backup:
1. Boot to TWRP
2. Re-flash your ROM zip (if possible)
3. Or Odin-flash stock firmware (BL + AP + CP + HOME_CSC)

### "Init userspace failed / Rescue Party"

This means RushKernel's kernel/vendor combination doesn't match your ROM's vendor partition. This can happen with very old ROMs or unusual mods.

Recovery: same as bootloop above.

### "Flash aborted with E3004 device check"

The kernel detected your device is NOT b0s. Don't try to bypass this — the kernel is hardware-specific and would brick incompatible devices.

### "BBR not available after reboot"

Run `lsmod | grep bbr` — if it's listed as a module, load it:
```bash
sudo modprobe tcp_bbr
sudo sysctl -w net.ipv4.tcp_congestion_control=bbr
```

If it's not built or available, the build may have failed silently. File an issue with your `uname -a` output.

---

## Uninstalling

To remove RushKernel and go back to your ROM's stock kernel:

1. Boot to TWRP
2. **Restore** → your previously-saved boot backup
3. Reboot

Or alternatively, re-flash your ROM zip — most ROMs include their own kernel.

---

## Updating

Same procedure as initial install:
1. Backup current boot
2. Flash new RushKernel zip
3. Reboot

No need to wipe data between updates.

---

## Reporting issues

When reporting a problem on [GitHub Issues](https://github.com/hacenbm144-spec/RushKernel/issues), please include:

- RushKernel version (filename of zip you flashed)
- Your ROM (BeyondROM 8.3, LineageOS 23.2, stock, etc.)
- Output of `uname -a`
- Description of what went wrong
- TWRP install log (`/sdcard/TWRP/last_log.txt`)
