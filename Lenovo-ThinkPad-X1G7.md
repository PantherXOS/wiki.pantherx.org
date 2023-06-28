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
helps you installing the PantherX on hardware

## Audio

For audio to work, add these kernel parameters to your config:

```scheme
 (host-name "panther")
 (timezone "Europe/Berlin")
 (locale "en_US.utf8")

 ;; This is the important part
 (kernel-arguments
 (cons* "snd_hda_intel.dmic_detect=0"
           %default-kernel-arguments))
```

## Display brightness function keys

If you are using a Thinkpad X1 your display brightness function keys on LXQt likely do not work out of the box.

### Test

Here's how you can confirm, if this solution will help you:

(1) Try running this as `root`:

```bash
echo 12000 >> /sys/class/backlight/intel_backlight/brightness
```

It should set your brightness to about 50% screen brightness.

(2) Now try running this again as user:

```bash
echo 24000 >> /sys/class/backlight/intel_backlight/brightness
```

This is supposed to maximize brightness, but will fail with a permission error.

If (1) worked, and (2) did not work, here's how-to get this working as user, and by keyboard shortcut.

### Solution

First of all, install _light_ (as user; not as root):

```bash
guix package - i light
```

Light makes it easier to interact with these brightness controls:

```bash
# increase
light -A 10
# decrease
light -U 10
```

This won't work at this point, as you do not have permissions yet. Let's configure permissions: Login as `root` and open the system configuration with

```bash
nano /etc/system.scm
# of if you prefer
emacs -nw /etc/system.scm
```

(1) First of all, add a new backlight udev rule below (use-modules) and (use-service-modules) section:

```scheme
;; Allow members of the "video" group to change the screen brightness.
(define %backlight-udev-rule
  (udev-rule
   "90-backlight.rules"
   (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/intel_backlight/brightness\""
                  "\n"
                  "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness\"")))
```

Next, look at your user account, and make sure you're actually in the video group (if you do not see the `video` group, simply add it. Don't worry about the other groups shown here):

```scheme
  (users (cons (user-account
                (name "franz")
                (comment "default")
                (group "users")
                (supplementary-groups '("wheel" "netdev" "docker" "kvm"
                                        "audio" "video" "lpadmin" "lp")))))
```

Lastly, look at your `(services)` section, and add the new udev-rules-service:

```scheme
(services (cons* 
                   ;; You probably have other stuff here already
                   (udev-rules-service 'backlight %backlight-udev-rule)))
```

Alright, puh ... almost a little too complicated, huh? Let's reconfigure:

```bash
guix system reconfigure /etc/system.scm
```

If everything goes well (no errors scream at you), go ahead and reboot.

You can confirm that this worked, by opening a terminal, and try changing your brightness:

```bash
# increase
light -A 10
# decrease
light -U 10
```

Of course you don't want to do this manually each time.

1. Open "Settings" in the Menu and look for "Shortcut Keys"
2. Add 2x new shortcuts, one to increase, and one to decrease
  - Shortcut: XF86MonBrightnessDown; Lower Brightness; Command: light -u 10
  - Shortcut: XF86MonBrightnessUp; Raise Brightness; Command: light -A 10
3. Enjoy

## See also

- https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_7)
