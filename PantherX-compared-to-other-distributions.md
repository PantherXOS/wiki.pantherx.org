---
---

## General

PantherX is a GNU Guix upstream distribution, with the aim to provide a more complete, lightweight and user friendly computing environment.

### GNU Guix

- contains no nonfree software but _PantherX_ makes them available, where superior (or necessary)
- supports GNU Hurd and Linux Libre as Kernel, _PantherX_ additionally supports nonfree Kernel
- relies on GNU Shepherd as init system, so does _PantherX_

Read more about the differences between Linux and Linux-libre on [stackexchange.com](https://unix.stackexchange.com/a/288174)

### Debian

- relies on systemd as init, _PantherX_ uses GNU Shepherd
- has a fixed release model with stable versions often shipping very old packages
- has a huge community that supports virtually all desktop environments without specific focus
- uses apt package manager

### Fedora

- relies on systemd as init, _PantherX_ uses GNU Shepherd
- releases a new version every 6 months, _PantherX_ uses a rolling release cycle
- supports various desktop environments including Gnome, KDE and LXQt. _PantherX_ supports only LXQt.

### Slackware

- Slackware uses BSD-style init scripts, _PantherX_ uses GNU Shepherd
- stable snapshots are available but many users rely on the `-current` branch which makes this effectively rolling
- package manager doesn't handle dependencies

### NixOS

- _GNU Guix_ and _PantherX_ where in large parts inspired by _NixOS_
- _Nix_ uses various languages, and a special DSL for packaging, _PantherX_ uses _Guile_ for everything

## Beginner-friendly

### Ubuntu

- is based on _Debian_ with _GNOME_ as default desktop environment. _PantherX_ defaults to a more lightweight LXQt.
- _Ubuntu_ relies on systemd as init, _PantherX_ uses GNU Shepherd
- has a fixed release model

### Linux Mint

- is based on Ubuntu with _Cinnamon_ as it's default desktop
- _Linux Mint_ relies on systemd as init, _PantherX_ uses GNU Shepherd
- has a fixed release model

### openSUSE

- _openSUSE_ relies on systemd as init, _PantherX_ uses GNU Shepherd
- uses KDE as default desktop environment but supports others as well
- is available as a stable and rolling release

### Manjaro

- is based on _Arch_ with _Xfce_ as it's default desktop
- both _Manjaro_ and _PantherX_ rely on a rolling release cycle
- _openSUSE_ relies on systemd as init, _PantherX_ uses GNU Shepherd

## See also

If you want to read a more in-depth comparison of GNU Guix with other distributions: [Guix: A most advanced operating system](https://ambrevar.xyz/guix-advance/)

- [DistroWatch](https://distrowatch.com/) - Linux distributions news and reviews
- [The Live CD List](https://livecdlist.com/) - List of Live operating systems images
