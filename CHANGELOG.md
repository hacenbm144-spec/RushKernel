# Changelog

All notable changes to RushKernel will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- BORE CPU scheduler patch evaluation
- LTO (Clang Thin) build option
- Per-app TCP congestion control selection
- PGO/BOLT optimized release builds

---

## [v1.0.0] — Initial release

### Added
- BBR TCP congestion control (default)
- FQ packet scheduler (default)
- TCP Fast Open
- MGLRU (Multi-Gen LRU) memory management
- ZRAM with zstd compression (default)
- ZSWAP enabled by default
- WireGuard built-in
- GitHub Actions CI/CD pipeline
- AnyKernel3 packaging

### Build
- Based on `ExtremeXT/android_kernel_samsung_s5e9925`
- Built with Proton Clang 13.0.0
- Linux 5.10 GKI base
- Targets `b0s` (SM-S908B) only

[Unreleased]: https://github.com/hacenbm144-spec/RushKernel/compare/v1.0.0...HEAD
[v1.0.0]: https://github.com/hacenbm144-spec/RushKernel/releases/tag/v1.0.0
