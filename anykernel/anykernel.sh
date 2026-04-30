### AnyKernel3 - RushKernel for Samsung Galaxy S22 Ultra Exynos (b0s)
### DEBUG VERSION - shows every operation

## AnyKernel setup
# begin properties
properties() { '
kernel.string=RushKernel by hacenbm144 [DEBUG BUILD]
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=0
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

# Pre-install diagnostics
ui_print " ";
ui_print "=== RushKernel Debug Info ===";
ui_print "Looking for boot block...";
ui_print "Block: $block";

# Try unpacking with verbose magiskboot output
ui_print " ";
ui_print "=== Manual unpack test ===";
cd $home;
dump_boot;
ui_print "Boot image dumped to $home/boot.img";
ls -la $home/boot.img 2>&1 | while read line; do ui_print "$line"; done;

ui_print " ";
ui_print "=== Magiskboot unpack ===";
cd $split_img;
$bin/magiskboot unpack -h boot.img 2>&1 | while read line; do ui_print "$line"; done;
ls -la 2>&1 | while read line; do ui_print "$line"; done;

ui_print " ";
ui_print "=== Replacing kernel ===";
ls -la $home/Image 2>&1 | while read line; do ui_print "$line"; done;
cp -f $home/Image kernel;
ls -la kernel 2>&1 | while read line; do ui_print "$line"; done;

ui_print " ";
ui_print "=== Repack attempt ===";
$bin/magiskboot repack boot.img new-boot.img 2>&1 | while read line; do ui_print "$line"; done;
ls -la new-boot.img 2>&1 | while read line; do ui_print "$line"; done;

ui_print " ";
ui_print "=== Writing boot ===";
write_boot;

ui_print " ";
ui_print "=== Done ===";