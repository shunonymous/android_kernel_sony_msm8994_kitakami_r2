#!/bin/sh

DEVICES=`find *diffconfig | sed s/[/_]*diffconfig//g | sed s/common//g | sed s/[\/]//g`

for device in $DEVICES
do
    cat msm8994-perf_defconfig diffconfig/common_diffconfig diffconfig/${device}_diffconfig > kitakami_${device}_defconfig
done
