---
---

## System administration

### Users and groups

Users and their associated groups are defined in the system configuration (`/etc/system.scm`).

For a single user, it may look like this:

```scheme
(users (cons (user-account
              (name "franz")
              (comment "default")
              (group "users")
              (supplementary-groups '("wheel" "netdev" "docker" "kvm"
                                      "audio" "video" "lpadmin" "lp"))
              (home-directory "/home/franz"))
             %base-user-accounts))
```

Note that I have quite a few supplementary groups:

- `wheel` to enable `sudo` use
- `netdev` for wifi management
- `kvm` mostly for hardware acceleration under qemu
- `audio` for audio playback
- `video` for webcam access
- `lpadmin` and `lp` to add, remove printers via cups (usually a web interface)

### Privilege escalation

### Service management

PantherX uses [shepherd](/Shepherd) as the init process, which is a system and service manager for Linux. For maintaining your Arch Linux installation, it is a good idea to learn the basics about it. Interaction with _shepherd_ is done through the _herd_ command.

Status:

```bash
herd status
```

Stop a service:

```bash
herd stop syncthing
```

Start a service:

```bash
herd start syncthing
```

Note: Access root services via `su - root`.

### System maintenance

To update all user packages:

```bash
px update apply
```

To update the operating system and all system and global packages:

```bash
su - root
px update apply
```

## Package management

### guix

[guix](/guix) is the PantherX package manager

Search a package:

```bash
guix package -s nheko
```

Install a package:

```bash
guix package -i nheko
```

Remove a package:

```bash
guix package -r nheko
```

Each user has their own packages:

- Packages installed under `root` are only accessible to the `root` user
- Packages a user installs in their own account, are only accessible to that user
- Only packages listed in the system configuration are accessible to all users automatically

We recommend that you use _Software_ to install and update applications on Desktop.

### Repositories

On PantherX, repositories are called "Channels". Here's what the default channels (`/etc/guix/channels.scm`) look like:

```scheme
;; PantherX Default Channels

(cons* (channel
        (name 'pantherx)
        (branch "master")
        (url "https://channels.pantherx.org/git/panther.git")
         (introduction
          (make-channel-introduction
           "54b4056ac571611892c743b65f4c47dc298c49da"
           (openpgp-fingerprint
            "A36A D41E ECC7 A871 1003  5D24 524F EB1A 9D33 C9CB"))))
       %default-channels)
```

### Mirrors

PantherX will try to download binary files ("Substitutes") from our own as well as guix build server's.

- `packages.pantherx.org`
- `build.pantherx.org` (depreciated)
- `ci.guix.gnu.org` (and mirrors)

If any server or binary is not available, the system will fall-back and build the file from source, on your computer.

## Power management

### ACPI events

### CPU frequency scaling

### Laptops

### Suspend and Hibernate

## Multimedia

### Sound

Configure input's and outputs using the Volume Control application.

Either:
- Click on the volume button in the task-bar and select "Mixer"
- Or open the Menu > Sound & Video > PulseAudio Volume Control

### Browser plugins

### Codecs

## Networking

### Clock synchronization

The time is updated automatically using `ntpd`. You can verify that it's running:

```bash
su - root
herd status ntpd
```

### DNS security

### Setting up a firewall

A default firewall is setup and and running, rejecting all incoming connections. You can verify it's running:

```bash
su - root
herd status nftables
```

Note: On PantherX Server, port 22 is open by default (not on Desktop).

### Resource sharing

## Input devices

Most input devices can be configured via _Settings_. Look for "Keyboard and Mouse".

## Optimization

### Benchmarking

### Improving performance

### Disk space

If you are running out of disk space, it might help clear old store items:

```bash
guix gc
```

## Appearance

### Display Scaling

If you are working on a high resolution screen and have a hard time reading the text, this one is for you. With a few manual adjustments, most if not all applications happily scale to 1.5x to 2x - likely others, if you go trough some trial and error.

Here's how:

1. Menu > Preferences > Advanced Settings > Session Settings
2. Look for "Environment (Advanced)" on the sidebar

The following values work well for me (2560x1440 on a 14" screen) but depending on your eyes, screen size and resolution, you might want to adjust.

```
GDK_DPI_SCALE = 1.5
GDK_SCALE = 1.5
QT_AUTO_SCREEN_SCALE_FACTOR = 0
QT_SCALE_FACTOR = 1.5
XCURSOR_SIZE = 26
```

To apply, simply log-out and back in. Better yet, reboot.

## System service

List all system services using:

```bash
su - root
herd status
```

### File index and search

Search on PantherX Desktop is powered by Recoll: A lightning-fast indexing and search application that looks trough PDF's, word documents, power points, spreadsheets, emails, calendar events, pictures and more.

Open the Menu and look for "Advanced Search"

### Printing

Until we have a proper GUI application, you can add and remove printers, and manage jobs at `http://localhost:631/admin`.

1. Open the page in your browser
2. Look for "Add printer"
3. Follow the steps

The printer should be available in most applications that support printing.
