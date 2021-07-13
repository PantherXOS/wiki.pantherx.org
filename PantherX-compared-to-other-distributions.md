---
---

## General

PantherX is a GNU Guix upstream distribution, with the aim to provide a more complete, lightweight and user friendly computing environment.

What sparked PantherX was one user's frustration with the direction of MacOS and the endless number of failed attempts to permanently switch to any of the "popular" Linux distributions. While far from perfect, PantherX has finally sealed the deal, and is improving on a daily basis. It just feels right and literally never breaks - much of this is thanks to it's roots in Guix and LXQt.

We owe our existance to the Guix and LXQt team.

### GNU Guix

- contains no nonfree software but PantherX makes them available, where superior (or necessary)
- supports GNU Hurd and Linux Libre as Kernel, PantherX additionally supports nonfree Kernel
- relies on GNU Shepherd as init system, so does PantherX

Read more about the differences between Linux and Linux-libre on [stackexchange.com](https://unix.stackexchange.com/a/288174)

### Debian

- relies on systemd as init, PantherX uses GNU Shepherd
- has a fixed release model with stable versions often shipping very old packages
- has a huge community that supports virtually all desktop environments without specific focus
- uses apt package manager

### Fedora

- relies on systemd as init, PantherX uses GNU Shepherd
- releases a new version every 6 months, PantherX uses a rolling release cycle
- supports various desktop environments including Gnome, KDE and LXQt. PantherX supports only LXQt.

### Slackware

- Slackware uses BSD-style init scripts, PantherX uses GNU Shepherd
- stable snapshots are available but many users rely on the `-current` branch which makes this effectively rolling
- package manager doesn't handle dependencies

### NixOS

- _GNU Guix_ and PantherX where in large parts inspired by _NixOS_
- _Nix_ uses various languages, and a special DSL for packaging, PantherX uses _Guile_ for everything
- supports various desktop environments

## Beginner-friendly

### Ubuntu

- is based on _Debian_ with _GNOME_ as default desktop environment. PantherX defaults to a more lightweight LXQt.
- _Ubuntu_ relies on systemd as init, PantherX uses GNU Shepherd
- has a fixed release model

### Linux Mint

- is based on Ubuntu with _Cinnamon_ as it's default desktop
- _Linux Mint_ relies on systemd as init, PantherX uses GNU Shepherd
- has a fixed release model

### openSUSE

- _openSUSE_ relies on systemd as init, PantherX uses GNU Shepherd
- uses KDE as default desktop environment but supports others as well
- is available as a stable and rolling release

### Manjaro

- is based on _Arch_ with _Xfce_ as it's default desktop
- both _Manjaro_ and PantherX rely on a rolling release cycle
- _openSUSE_ relies on systemd as init, PantherX uses GNU Shepherd

## See also

If you want to read a more in-depth comparison of GNU Guix with other distributions: [Guix: A most advanced operating system](https://ambrevar.xyz/guix-advance/)

- [DistroWatch](https://distrowatch.com/) - Linux distributions news and reviews
- [The Live CD List](https://livecdlist.com/) - List of Live operating systems images
