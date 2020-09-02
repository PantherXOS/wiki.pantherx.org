---
namespace: flatpak
description: "Flatpak is a utility for software deployment and package management for Linux. It is advertised as offering a sandbox environment in which users can run application software in isolation from the rest of the system. Flatpak was developed as part of the freedesktop.org project (formerly known as X Desktop Group or XDG) and was originally called xdg-app."
description-source: "https://en.wikipedia.org/wiki/Flatpak"
categories:
 - type:
   - "Application"
 - location:
   - "Package management"
language: en
---

Flatpak enables you to run some popular applications that are not yet available trough PantherX Software.

- [Signal Desktop](https://flathub.org/apps/details/org.signal.Signal): Private messenger
- [VSCodium](https://flathub.org/apps/details/com.vscodium.codium): Code editor
- [Element (Riot)](https://flathub.org/apps/details/im.riot.Riot): Team and community chat

## Install Flatpak

First, install Flatpak:

```bash
guix package -i flatpak
```

### Configure Flatpak

1. Open **Session Settings**.
2. Go to "Environment (Advanced)"
3. Add this variable:

| Variable Name 	| Value                                         	|
|---------------	|-----------------------------------------------	|
| XDG_DATA_DIRS 	| $XDG_DATA_DIRS:/var/lib/flatpak/exports/share 	|

For the changes to take effect, you will need to log out.

## Install Application (Example: Signal)

Go to [flathub.org](https://flathub.org/apps/details/org.signal.Signal) and click "Install". This will download a `org.signal.Signal.flatpakref`.

Navgiate to your download folder, and install Signal Desktop:

```bash
cd ~/Downloads
sudo flatpak install org.signal.Signal.flatpakref
```

Accept and continue. That's it.

You can now delete the flatpak reference:

```bash
rm ~/Downloads/org.signal.Signal.flatpakref
```

## Run Application

_Note: Due to a bug, you may have to log out in order for the **Menu** items to reload, and newly installed applications to show up._

1. Open the _start_ **Menu**
2. Go to "Internet"
3. Click on "Signal"

You're now running Signal Desktop on PantherX.

## Update Application

This will look for updates, for all installed Flatpak-managed applications.

```bash
sudo flatpak update
```

## Remove Application

To remove one application:

```bash
sudo flatpak remove org.signal.Signal
```

To remove all Flatpak-managed applications:

```bash
sudo flatpak remove --all
```
