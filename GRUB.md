---
namespace: grub
description: "GNU GRUB (short for GNU GRand Unified Bootloader, commonly referred to as GRUB) is a boot loader package from the GNU Project."
description-source: "https://en.wikipedia.org/wiki/GNU_GRUB"
categories:
  - type:
      - "Bootloader"
  - location:
      - "General"
language: en
---

## Troubleshooting

### GRUB does not boot

If you ever run into a situation where GRUB refuses to boot, here's one possible fix:

```
error: file `/boot/grub/x86_64-efi/priority_queue.mod` not found.
Entering rescue mode...
grub rescue>
```

1. Boot from a PantherX ISO or USB
2. Select command line
3. Repair GRUB by following these steps

This is assuming you're on an EFI system with two partitions on `/dev/sda`. Adapt as required.

```
mkdir /tmp/guix
mount /dev/sda2 /tmp/guix
mount -t proc none /tmp/guix/proc
mount -t sysfs sys /tmp/guix/sys
mount -o bind /dev /tmp/guix/dev
mount /dev/sda1 /tmp/guix/boot/efi
```

Chroot into your system, run the guix build deamon and reconfigure:

```
sudo chroot /tmp/guix /bin/sh
guix-daemon --build-users-group=guixbuild --disable-chroot &
guix system reconfigure /etc/system.scm
```
