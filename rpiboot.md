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

## Installation

```bash
git clone --depth=1 https://github.com/raspberrypi/usbboot
cd usbboot
```

Launch a new environment and compile:

```bash
guix environment --pure libusb gcc-toolchain make python-libusb1 bash sudo
make CC=gcc
```

## Run

If you're not already in the environment:

```bash
guix environment --pure libusb gcc-toolchain make python-libusb1 bash sudo
```

and run:

```bash
$ ./rpiboot
RPIBOOT: build-date Feb 24 2022 version 20220208~181027
Waiting for BCM2835/6/7/2711...
```
