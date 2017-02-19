#!/bin/sh

# Set target device from commandline args
if [ $# -eq 1 ]
then
    export TARGET_DEVICE=$1
else
    echo "usage: $0 <device>"
    echo "ex: $0 satsuki"
    exit 1
fi

# Set parameters
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-android-
export GCC_VERSION=5.x
export PATH=$HOME/bin/${CROSS_COMPILE}${GCC_VERSION}/bin:$PATH
export KBUILD_DIFFCONFIG=${TARGET_DEVICE}_diffconfig

# CCache
export USE_CCACHE=1

# build
make clean
make msm8994-perf_defconfig
make -j4

# Assembling the boot.img
if [ $? -eq 0 ]
then
    mkbootimg \
      --kernel arch/arm64/boot/Image.gz-dtb \
      --ramdisk ../initrd.img \
      --cmdline "androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 boot_cpus=0-5 dwc3_msm.prop_chg_detect=Y coherent_pool=2M dwc3_msm.hvdcp_max_current=1500" \
      --base 0x00000000 \
      --pagesize 4096 \
      --ramdisk_offset 0x02000000 \
      --tags_offset 0x01E00000 \
      --output ../boot.img

    echo "Build successful!"
fi
