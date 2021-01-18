---
namespace: lenovo
description:
categories:
 - type:
   - "Guide"
 - location:
   - "Hardware"
   - "Laptops"
   - "Lenovo"
language: en
---

This article covers details pertaining to installing and configuring PantherX OS
on a Lenovo Thinkpad X1 Gen 7 laptop.

## Before Install

replacing the the upstream libre kernel with linux nonfree kernel, most of hardwares
work as expected.

## Installation

Supports both UEFI and MBR style bios. The [Installation guide](/Installation-guide/)
helps you installing the PantherX on hardware, you only need to replace the kernel
definition in system configuration file:

```scheme
(use-modules ...
             (nongnu packages linux)
             (nongnu system linux-initrd)
             ...)

(operating-system
  ...
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  ...)
```

## Audio

For audio to work, add these kernel parameters to your config:

```scheme
(kernel-arguments
   (cons* "snd_hda_intel.dmic_detect=0"
          %default-kernel-arguments))
```

_TODO: System config example_

## See also

- https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_7)
