#!/bin/sh

set -euo pipefail

BAD=v6.8-rc1
GOOD=v6.1

./prepare.sh

cd linux
git bisect start
git bisect bad $BAD
git bisect good $GOOD
git bisect run sh -c 'make defconfig && nice -n 20 make -j WERROR=0 EXTRA_CFLAGS="-Wno-error" bzImage && cd .. && ./run-for-kernel.sh linux/arch/x86/boot/bzImage | grep "^XXX: OK"'
