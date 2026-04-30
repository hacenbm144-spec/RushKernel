### AnyKernel3 - RushKernel for Samsung Galaxy S22 Ultra Exynos (b0s)
### Maintained by hacenbm144 | Based on osm0sis AnyKernel3

## AnyKernel setup
# begin properties
properties() { '
kernel.string=RushKernel by hacenbm144
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=b0s
device.name2=SM-S908B
device.name3=b0sxxx
device.name4=b0sxx
device.name5=b0sks
supported.versions=14,15,16
supported.patchlevels=
'; } # end properties

block=auto;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

## AnyKernel install
. tools/ak3-core.sh;

## boot install
write_boot;

## end install
