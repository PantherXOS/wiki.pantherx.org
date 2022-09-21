---
namespace: raspberry
description: "The reTerminal is a Human-Machine Interface facility, designed in modularization, offered multiple interfaces and components. It is your hand-size, powerful, Raspberry Pi-based all-in-one board, assisting you to develop individual IoT & AI projects and being ready to materialize industrial-level monitor and control functions."
description-source: "https://www.seeedstudio.com/ReTerminal-with-CM4-p-4904.html"
categories:
  - type:
      - "Guide"
  - location:
      - "Hardware"
      - "ARM"
      - "SEEED"
language: en
---


## Flash Image

### Get rpiboot

Before you can mount (and flash) the reTerminal from your desktop, you need to obtain and compile a helper called `rpiboot`. Here's how-to do that:

```bash
cd ~/
git clone --depth=1 https://github.com/raspberrypi/usbboot
cd usbboot
sudo apt install libusb-1.0-0-dev
make
```

You should now have the executable `rpiboot` at `~/usbboot/rpiboot`.

### Download OS Image

Download and extract the OS image:

```bash
cd ~/
wget https://temp.pantherx.org/1pyaw9ds5hh4ajzg9wi46d0vxxk58bzq-reterminal-core-image.xz
xz --decompress 1pyaw9ds5hh4ajzg9wi46d0vxxk58bzq-reterminal-core-image.xz
```

### Switch reTerminal to boot mode

Open the back of reTerminal, remove heat sink and toggle the boot switch beside the CM4 board.

### Plugin & mount

Plugin the USB-C cable and mount the reTerminal internal eMMC on your desktop using the following command (run in `~/usbboot` folder):

```bash
# usbboot folder on PC updating reTerminal
$ sudo ./rpiboot
RPIBOOT: build-date Feb 24 2022 version 20220208~181027
Waiting for BCM2835/6/7/2711...
Loading embedded: bootcode4.bin
Sending bootcode.bin
Successful read 4 bytes
Waiting for BCM2835/6/7/2711...
Loading embedded: bootcode4.bin
Second stage boot server
Loading embedded: start4.elf
File read: start4.elf
Second stage boot server done
```

Double-check that the reTerminal eMMC is mounted using `lsblk`. It should look something like this (29.1G):

```bash
$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda             8:16   1  29.1G  0 disk           <-------- This is what we're looking for "sda" or "sdb" or ...
├─sda1          8:17   1   256M  0 part  /media/someuser/boot
└─sda2          8:18   1   3.6G  0 part  /media/someuser/rootfs
nvme0n1       259:0    0 953.9G  0 disk
├─nvme0n1p1   259:1    0   549M  0 part  /boot/efi
└─nvme0n1p2   259:2    0 953.3G  0 part
  └─cryptroot 253:0    0 953.3G  0 crypt /var/lib/docker
                                         /gnu/store
                                         /
```

**The reTerminal eMMC should now be mounted on the desktop.**

Before flashing, unmount these drives:

```bash
# Note: If your OS does not automatically mount USB drives, this might not be necessary
umount /media/someuser/boot
umount /media/someuser/rootfs

# FOR EXAMPLE
umount /media/max/boot
umount /media/max/rootfs
```

### Flash image

Proceed to flash the new OS to the eMMC with:

```bash
cd ~/
# Note /dev/sda; the "sda" comes from the previous step
sudo dd if=1pyaw9ds5hh4ajzg9wi46d0vxxk58bzq-reterminal-core-image of=/dev/sda status=progress
sudo sync
```

After completion, make sure none of the partitions are mounted and remove the USB-C cable.

You can confirm the drive is unmounted:

```bash
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda             8:0    1     0B  0 disk        <-------- note: no more sda1, sda2 (or sdb, sdc, ..)
nvme0n1       259:0    0 953.9G  0 disk
├─nvme0n1p1   259:1    0   549M  0 part  /boot/efi
└─nvme0n1p2   259:2    0 953.3G  0 part
...
```

### Switch boot mode

Toggle the firmware switch on the CM4 board in the other direction.


## First boot

On initial boot, the OS will automatically:

- Expand the disk partition to fill all available space
- Create a SWAP file

This might take 2-3 minutes, so wait a moment before you start using the device.

Credentials:

```
Username: panther
Password: pantherx
```

### Usage

To update the image, login as root, and run:

```bash
px update apply
```

_The image is still a work in progress; Your initial update might easily take an hour._

To update your system configuration after changing `system.scm` run:

```bash
px reconfigure
```

## Configuration example

To reconfigure your image, use the following configuration examples as reference.

1. Create / update the configuration at `/etc/system.scm`
2. Run `px reconfigure` as root

### Server Configuration

- Replace `ssh-ed25519 AAAAC3NzaC1...............ydPg panther` with your SSH key

```scheme
{% include config-examples/px-server-os-reterminal.scm %}
```

## See also

- [System Configuration](/System-configuration/)