# RushKernel

[![Build RushKernel](https://github.com/hacenbm144-spec/RushKernel/actions/workflows/build-kernel.yml/badge.svg)](https://github.com/hacenbm144-spec/RushKernel/actions/workflows/build-kernel.yml)
[![License: GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Device](https://img.shields.io/badge/device-SM--S908B-green.svg)](https://www.samsung.com/global/galaxy/galaxy-s22-ultra/)

A modern, performance-tuned custom kernel for the **Samsung Galaxy S22 Ultra (Exynos)** — codename `b0s`, model `SM-S908B`.

Built from the actively maintained [ExtremeXT kernel source](https://github.com/ExtremeXT/android_kernel_samsung_s5e9925) with carefully chosen networking, memory, and scheduling improvements.

---

## Why RushKernel

The stock Samsung kernel is solid but conservative — many modern Linux kernel features that benefit phones are disabled by default. RushKernel turns these on, with a focus on:

- **Network performance** under poor cellular conditions (BBR + FQ)
- **Memory responsiveness** under multitasking pressure (MGLRU + ZRAM-zstd)
- **Modern tooling** support (built-in WireGuard)

No magic, no placebo tweaks — just well-understood kernel features that make a measurable difference.

---

## Features

### Network stack
| Feature | Effect |
|---------|--------|
| **BBR TCP congestion control** (default) | 2-25× better throughput on lossy networks |
| **FQ packet scheduler** (default) | Fair queueing, lower bufferbloat |
| **TCP Fast Open** | Reduced connection setup latency |

### Memory management
| Feature | Effect |
|---------|--------|
| **MGLRU** (Multi-Gen LRU) | Better responsiveness under memory pressure |
| **ZRAM with zstd** | Higher compression ratio for swap |
| **ZSWAP enabled** | Compressed cache for swap pages |

### Networking
| Feature | Effect |
|---------|--------|
| **WireGuard built-in** | Native fast/secure VPN, no userspace daemon |

---

## Installation

See [docs/INSTALL.md](docs/INSTALL.md) for the full guide.

**Quick version:**
1. Download the latest `RushKernel-*.zip` from [Releases](https://github.com/hacenbm144-spec/RushKernel/releases)
2. Boot to TWRP / OrangeFox recovery
3. **Make a backup of your current boot image first!**
4. Install the zip
5. Reboot

⚠️ **Compatibility:** Only flash on **SM-S908B (b0s)**. The kernel will refuse to install on other devices.

---

## Building from source

See [docs/BUILD.md](docs/BUILD.md) for instructions on building locally or via your own GitHub Actions fork.

---

## Compatibility

- **Device:** Samsung Galaxy S22 Ultra Exynos only — `SM-S908B`
- **Android versions:** 14, 15, 16
- **ROM compatibility:** Stock Samsung firmware, BeyondROM, LineageOS, UN1CA — anything based on Samsung GKI 5.10
- **Bootloader:** Any (vbmeta is patched at flash time)

⚠️ **NOT compatible** with:
- SM-S908U / SM-S908N (Snapdragon variants — different SoC)
- S22 / S22+ (different device codenames — `r0s` / `g0s`)
- Other devices

---

## Roadmap

- [x] Initial release with BBR, FQ, MGLRU, ZRAM-zstd, WireGuard
- [ ] BORE CPU scheduler patch evaluation
- [ ] LTO (Clang Thin) build option
- [ ] Per-app TCP congestion control selection
- [ ] PGO/BOLT optimized release builds

---

## Credits & licensing

This project stands on the shoulders of giants:

- **[ExtremeXT](https://github.com/ExtremeXT)** — kernel source for Exynos 2200 / s5e9925 family
- **[osm0sis](https://github.com/osm0sis)** — AnyKernel3 flashable framework
- **[kdrag0n](https://github.com/kdrag0n)** — Proton Clang toolchain
- **Linux kernel developers** for BBR, MGLRU, ZRAM, WireGuard, and everything else

Licensed under **GPL-2.0** — same as the upstream Linux kernel. See [LICENSE](LICENSE).

---

## Disclaimer

This is unofficial software. Flashing custom kernels can result in:
- Bootloops
- Loss of data
- Voided warranty
- Tripped Samsung Knox (permanent)

You assume all risk. The author is not responsible for any damage. Always have a recovery plan (TWRP backup, Odin firmware ready) before flashing.

---

## Contact

- Issues / bug reports: [GitHub Issues](https://github.com/hacenbm144-spec/RushKernel/issues)
- Author: [@hacenbm144-spec](https://github.com/hacenbm144-spec)
