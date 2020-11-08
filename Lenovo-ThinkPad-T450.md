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
on a Lenovo Thinkpad T450 laptop.

## Before Install

replacing the the upstream libre kernel with linux nonfree kernel, most of hardwares
work as expected, the only issue is the LTE module, which it seems that it is a general
issue with linux, and LTE module don't work on other disros either.

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

## See also

- https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_T450
