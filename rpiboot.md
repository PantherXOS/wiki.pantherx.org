---
namespace: raspberry
description: "Raspberry Pi USB booting code"
description-source: ""
categories:
  - type:
      - "Application"
  - location:
      - "Development"
language: en
---

This guide focuses on:

- Mounting RPI CM4 with eMMC as mass storage on PantherX
- Updating RPI CM4 EEPROM from PantherX

## Installation

```bash
git clone --depth=1 https://github.com/raspberrypi/usbboot
cd usbboot
```

Launch a new environment and compile:

```bash
guix environment --pure libusb gcc-toolchain make python-libusb1 bash xxd openssl sudo
make CC=gcc
```

## Run

These instructions primarily relate to the Raspberry CM4 with eMMC.

### Mount SD Storage

If you're not already in the environment:

```bash
guix environment --pure libusb gcc-toolchain make python-libusb1 bash xxd openssl sudo
```

and run:

```bash
$ sudo ./rpiboot
RPIBOOT: build-date Feb 24 2022 version 20220208~181027
Waiting for BCM2835/6/7/2711...
```

### Update EEPROM

More on that [here](https://www.raspberrypi.com/documentation/computers/compute-module.html#cm4bootloader)

Before you start, update the boot order as described on the linked page. (Edit the default boot.conf bootloader configuration file. For SD/EMMC boot BOOT_ORDER=0xf1)

```
cd recovery
$ ./update-pieeprom.sh
+ /home/franz/git/usbboot/tools/rpi-eeprom-config --config boot.conf --out pieeprom.bin pieeprom.original.bin
+ set +x
new-image: pieeprom.bin
source-image: pieeprom.original.bin
config: boot.conf
```

Next, plugin the RPI and update the firmware (the switch should be set accordingly):

```bash
../rpiboot -d .
RPIBOOT: build-date Feb 24 2022 version 20220208~181027
Loading: ./bootcode4.bin
Waiting for BCM2835/6/7/2711...
Loading: ./bootcode4.bin
...
```

If you are listening on UART, the update will look something like this:

```bash
SIG pieeprom.sig 5164c78e5b57d0b8a93bce373e74bd6a02e9d77fedc708859ea8b5a2b16f0483 1645953211
Reading EEPROM: 524288
Writing EEPROM
+++++++++++++++++++++++++++*****++++++++++++++++++++++++++++++++++++++++++++++++++****************.............................+
Verify BOOT EEPROM
Reading EEPROM: 524288
BOOT-EEPROM: UPDATED
```

## Troubleshooting

### Permission to access USB device denied. Make sure you are a member of the plugdev group.

Either reconfigure your system, and add the user to the `plugdev` group, or login as root:

```bash
su - root
cd usbboot
guix environment --pure libusb gcc-toolchain make python-libusb1 bash xxd openssl
./rpiboot
```
