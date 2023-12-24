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

Flatpak enables you to run some popular applications that are not yet available trough **Software**.

## Install Flatpak

First, install Flatpak:

```bash
guix package -i flatpak
```

### Configure Flatpak

#### Desktop Icons on LXQT

1. Open **Session Settings**.
2. Go to "Environment (Advanced)"
3. Add this variable:

| Variable Name 	| Value                                         	|
|---------------	|-----------------------------------------------	|
| XDG_DATA_DIRS 	| $XDG_DATA_DIRS:/var/lib/flatpak/exports/share:${HOME}/.local/share/flatpak/exports/share 	|

For the changes to take effect, you will need to log out.

#### Desktop Icons LXQT, Mate, Gnome, XFCE

1. Open `~/.bash_profile`
2. Append the following line and save

```bash
source ~/.guix-profile/etc/profile.d/flatpak.sh
```

### Install Application (Example: Signal)

**Important**: We recommend that you append the `--user` flag to all Flatpak related commands, to ensure that you do not require _root_ priviliges in order to install, update or remove the applications.

- `flatpak --user` for install, update, uninstall
- `flatpak` for remaining commands (for ex. search)

#### Manually

Go to [flathub.org](https://flathub.org/apps/details/org.signal.Signal) and click "Install". This will download a `org.signal.Signal.flatpakref`.

Navgiate to your download folder, and install Signal Desktop:

```bash
$ cd ~/Downloads
$ flatpak --user install org.signal.Signal.flatpakref
```

Accept and continue. That's it.

You can now delete the flatpak reference:

```bash
$ rm ~/Downloads/org.signal.Signal.flatpakref
```

#### Via CLI

Search for a application:

```bash
$ flatpak search postman
Name             Description                                                 Application ID                  Version          Branch         Remotes
Postman          Postman is a complete API development environment.          com.getpostman.Postman          7.31.0           stable         flathub
```

Install application:

```bash
$ flatpak install --user com.getpostman.Postman
Looking for matches…
Found similar ref(s) for ‘com.getpostman.Postman’ in remote ‘flathub’ (user).
Use this remote? [Y/n]: y

com.getpostman.Postman permissions:
    ipc    network    pulseaudio    x11    file access [1]    dbus access [2]

    [1] home
    [2] com.canonical.AppMenu.Registrar


        ID                              Branch          Op          Remote          Download
 1. [✓] com.getpostman.Postman          stable          i           flathub         130.9 MB / 131.5 MB

Installation complete.
```

### Run Application

_Note: Due to a bug, you may have to log out in order for the **Menu** items to reload, and newly installed applications to show up._

1. Open the _start_ **Menu**
2. Go to "Internet"
3. Click on "Signal"

You're now running Signal Desktop on PantherX.

### Update All Applications

This will look for updates, for all installed Flatpak-managed applications.

```bash
$ flatpak --user update
```

### Remove Application

To remove one application:

```bash
$ flatpak --user remove org.signal.Signal
```

To remove all Flatpak-managed applications:

```bash
$ flatpak --user --all remove
```

## Additional Configuration

Software that you install from Flatpak might behave differently from what you're used to.
For example, for OSS-Code (VSCodium) to take advantage of proper code indexing, linting and debugging, you need to install an extension, to support this.

In my case, I needed node12:

> This SDK extension allows you to build and run Node.js-based apps.

To find your desired extension:

```sh
$ flatpak search org.freedesktop.Sdk.Extension.node
Name                           Description                    Application ID                           
Node.js SDK extension          Node.js SDK extension          org.freedesktop.Sdk.Extension.node12     
Node.js SDK extension          Node.js SDK extension          org.freedesktop.Sdk.Extension.node10     
```

**Tip** Simply search their [GitHub repositories](https://github.com/flathub?q=org.freedesktop.Sdk.Extension&type=&language=)

To install the extension:

```sh
$ flatpak --user install org.freedesktop.Sdk.Extension.node12
```

Sometimes you may encounter multiple versions, of the same package. It's usually best, to install the latest version.

```sh
Similar refs found for ‘org.freedesktop.Sdk.Extension.node10’ in remote ‘flathub’ (system):

1) runtime/org.freedesktop.Sdk.Extension.node10/x86_64/19.08
2) runtime/org.freedesktop.Sdk.Extension.node10/x86_64/20.08
3) runtime/org.freedesktop.Sdk.Extension.node10/x86_64/18.08
```

To enable the extension:

```
$ FLATPAK_ENABLE_SDK_EXT=node12; flatpak run com.visualstudio.code-oss
```

Once you start working, you might be prompted to allow the extension.

### Flatpak issue with Guix profile packages

since Flatpak packages run in a sand-boxed mode, they don't have access to system paths like `/var`.
since profiles are located in `/var/guix/profiles` path, they are not accessible for flapak packages 
by default and if you need to allow an application to have access to them, you need to provide access
explicitly using `--filesystem` switch:

```bash
$ flatpak run --filesystem=/var/guix/profiles com.visualstudio.code-oss
```

 this workaround helps fixing intellisense issue in IDEs like `vscode`.

**Note:** using this approach we still have issues during package build in C++ apps (during link time),
and this issue only resolves the intellisense issue.

*Reference:* [Flatpak official documents](https://docs.flatpak.org/en/latest/sandbox-permissions.html#filesystem-access)
