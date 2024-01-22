#!/bin/bash

exec qemu-system-x86_64 -nographic -kernel $1 -m 1G -initrd ./initramfs.gz -append "root=/dev/ram0 console=ttyS0 init=/init"
