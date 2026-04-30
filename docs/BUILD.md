# Building RushKernel

This guide covers building RushKernel locally and via GitHub Actions.

## Build via GitHub Actions (recommended)

The included workflow builds RushKernel automatically on every push to `main` that touches kernel-relevant files.

### Manual trigger

1. Go to the repo's **Actions** tab
2. Select **Build RushKernel**
3. Click **Run workflow**
4. Choose options:
   - `kernel_branch`: leave empty for default, or specify a branch
   - `create_release`: check to publish as a GitHub Release
   - `version`: e.g. `v1.0.0`
5. Click green **Run workflow** button

Build takes 30-45 minutes on free GitHub-hosted runners.

### Outputs

After a successful build:
- **Artifact:** flashable AnyKernel3 zip (in the run's artifacts)
- **Release:** if you checked the box, a GitHub Release is created with the zip and SHA256 hash
- **Build log:** uploaded as separate artifact for debugging

---

## Building locally

### Requirements

- Linux machine (Ubuntu 22.04 recommended) or WSL2 on Windows
- Git, build-essential, and Linux kernel build tools
- ~50 GB free disk space
- 16 GB RAM recommended (8 GB minimum)

### Setup

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y \
  bc bison flex libssl-dev make libelf-dev \
  libncurses5-dev zstd lz4 cpio python3 git \
  wget unzip device-tree-compiler ccache

# Clone this repo
git clone https://github.com/hacenbm144-spec/RushKernel
cd RushKernel

# Clone the kernel source
git clone --depth=1 \
  https://github.com/ExtremeXT/android_kernel_samsung_s5e9925 kernel

# Set up Clang toolchain
mkdir toolchain
cd toolchain
wget https://github.com/kdrag0n/proton-clang/releases/download/20210522/proton-clang-13.0.0.tar.zst
zstd -d proton-clang-13.0.0.tar.zst
tar -xf proton-clang-13.0.0.tar
mv proton-clang-* clang
cd ..
```

### Build

```bash
# Apply RushKernel customizations
cp config/rushkernel.fragment kernel/arch/arm64/configs/

cd kernel
export PATH="$(pwd)/../toolchain/clang/bin:$PATH"

# Configure
make O=out ARCH=arm64 \
  LLVM=1 LLVM_IAS=1 \
  CC=clang \
  CROSS_COMPILE=aarch64-linux-gnu- \
  CROSS_COMPILE_COMPAT=arm-linux-gnueabi- \
  s5e9925_defconfig b0s.config rushkernel.fragment

# Build (parallelize to your CPU count)
make -j$(nproc) O=out ARCH=arm64 \
  LLVM=1 LLVM_IAS=1 \
  CC=clang \
  CROSS_COMPILE=aarch64-linux-gnu- \
  CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
```

Build output will be in `kernel/out/arch/arm64/boot/`:
- `Image.lz4` — compressed kernel
- `Image` — raw kernel
- `dtbo.img` — device tree overlay

### Package as AnyKernel3 zip

```bash
cd ..
git clone --depth=1 https://github.com/osm0sis/AnyKernel3
cp anykernel/anykernel.sh AnyKernel3/
cp kernel/out/arch/arm64/boot/Image.lz4 AnyKernel3/
cp kernel/out/arch/arm64/boot/dtbo.img AnyKernel3/

cd AnyKernel3
zip -r9 ../RushKernel-local-build.zip . -x ".git/*" "README.md"
```

The zip is now ready to flash via TWRP.

---

## Customizing

### Changing kernel features

Edit `config/rushkernel.fragment` and add or remove `CONFIG_*` lines.

To find available kernel options:
```bash
cd kernel
make O=out ARCH=arm64 menuconfig
```

This opens an interactive UI to browse all kernel options. Press `/` to search, `?` for help.

### Changing the kernel source branch

In `.github/workflows/build-kernel.yml`, run the workflow manually and specify a branch in the `kernel_branch` input. Or for permanent change, edit the workflow.

### Adding kernel patches

Place patch files in a new `patches/` directory, then add a step to the workflow:
```yaml
- name: Apply RushKernel patches
  run: |
    cd kernel
    for patch in ../patches/*.patch; do
      git apply "$patch"
    done
```

---

## Troubleshooting builds

### "make: error: arch/arm64/configs/s5e9925_defconfig: no such file"

The kernel source path is wrong, or the upstream renamed the defconfig. Check:
```bash
ls kernel/arch/arm64/configs/
```

### "clang: error: unsupported option"

Toolchain mismatch. ExtremeXT may have moved to a newer Clang. Try downloading a newer Proton Clang or AOSP Clang.

### Build runs out of memory

Reduce parallelism: `make -j4` instead of `-j$(nproc)`.

### Long compile time

Enable ccache to speed up subsequent builds:
```bash
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
ccache -M 50G
```

First build is still slow. Subsequent builds with ccache are 5-10× faster.
