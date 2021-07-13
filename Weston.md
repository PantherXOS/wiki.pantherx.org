---
namespace: weston
description: "Weston is the reference implementation of a Wayland compositor also developed by the Wayland project. It is written in C and published under the MIT License. Weston only has official support for the Linux operating system due to its dependence on certain features of the Linux kernel, such as kernel mode-setting, Graphics Execution Manager (GEM), and udev, which have not been implemented in other Unix-like operating systems."
description-source: "https://en.wikipedia.org/wiki/Wayland_(display_server_protocol)#WESTON"
categories:
 - type:
   - "Application"
 - location:
   - "System administration"
   - "Graphical user interfaces"
   - "Desktop environments"
language: en
---

Weston is a lightweight and functional Wayland compositor.

## Installation

**We do not support this. If you know what you're doing, this is a reference to get started working with Weston on PantherX.**

### Global Installation

TODO

### User Profile Installation

To install _weston_, run:

```bash
$ guix package -i weston
```

## Starting the desktop

### From terminal

To launch _weston_, we need to set a number of environment variables:

```bash
$ export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
$ echo $XDG_RUNTIME_DIR
$ /tmp/0-runtime-dir
$ mkdir "${XDG_RUNTIME_DIR}"
$ chmod 0700 "${XDG_RUNTIME_DIR}"
```

Now launch _weston_:

```bash
$ weston-launch
```

## See also

- [weston source code](https://gitlab.freedesktop.org/wayland/weston/) on GitLab
