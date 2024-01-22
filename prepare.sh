#!/bin/bash

set -euo pipefail

rm -f initramfs.gz initramfs.zst
rm -Rf initramfs

mkdir -p initramfs/{bin,proc,dev}

cd reproduction
cargo build --release
cd ..
cp reproduction/target/x86_64-unknown-linux-gnu/release/bug-reproduction initramfs/bug-reproduction

cp bin/busybox initramfs/bin
cp bin/init initramfs/init
chmod +x initramfs/init

ln -s busybox initramfs/bin/sh
ln -s busybox initramfs/bin/poweroff
ln -s busybox initramfs/bin/mount
ln -s busybox initramfs/bin/uname

ln -s busybox initramfs/bin/mknod
ln -s busybox initramfs/bin/ls
ln -s busybox initramfs/bin/cd
ln -s busybox initramfs/bin/dd
ln -s busybox initramfs/bin/stat
ln -s busybox initramfs/bin/grep
ln -s busybox initramfs/bin/dmesg

cd initramfs
find . | cpio -H newc -o | gzip -n > ../initramfs.gz
cd ..
