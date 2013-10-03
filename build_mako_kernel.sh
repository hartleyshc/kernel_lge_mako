#!/bin/bash
# Copyright (C) 2013 Rusty
# credits to sparksco for the SaberMod kernel buildscript as base
# Build Script. Use bash to run this script, bash mako-kernel from source directory
export MANUFACTURER=lge;
export DEVICE=mako;

# GCC
export CC=$HOST_CC;
export CXX=$HOST_CXX;

# Source Directory PATH
export DIRSRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# Where prebuilt modules will be stored for installation into the ROM
export MODULES_DEST=$DIRSRC/vendor/psx/prebuilts/mako/system/lib/modules;

# Kernel Source PATH
export KERNELSRC=$DIRSRC/kernel/$MANUFACTURER/$DEVICE;

# Target gcc version
export TARGET_GCC=4.7;
export ARM_EABI_TOOLCHAIN=$DIRSRC/prebuilts/gcc/linux-x86/arm/arm-eabi-$TARGET_GCC;
export PATH=$PATH:$ARM_EABI_TOOLCHAIN/bin:$ARM_EABI_TOOLCHAIN/arm-eabi/bin;


# Build ID
export LOCALVERSION="-PSK-V1"
export KBUILD_BUILD_USER=PSX
export KBUILD_BUILD_HOST="PURE-SPEED-KERNEL"

# Cross compile with arm
export ARCH=arm;
export CCOMPILE=$CROSS_COMPILE;
export CROSS_COMPILE=$ARM_EABI_TOOLCHAIN/bin/arm-eabi-;

# Start the build
echo "";
echo "Starting the kernel build";
echo "";
cd $KERNELSRC 
make -C $KERNELSRC $J mako_defconfig 
time make -j4 -C $KERNELSRC $J zImage ;

if [ -e $KERNELSRC/arch/arm/boot/zImage ] ;
then
cp $KERNELSRC/arch/arm/boot/zImage -f $DIRSRC/device/$MANUFACTURER/$DEVICE-kernel/zImage;

else
echo "":
    echo "error detected in kernel build, now exiting";
    exit 1;
fi;
cd $DIRSRC;
echo "Kernel build finished, Continuing with ROM build";
echo "";

