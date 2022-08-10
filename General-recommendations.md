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

(list (channel
        (name 'guix)
        (url "https://channels.pantherx.org/git/pantherx.git")
        (branch "rolling-nonlibre"))
      (channel
        (name 'nongnu)
        (url "https://channels.pantherx.org/git/nongnu.git")
        (branch "rolling"))
      (channel
        (name 'pantherx)
        (url "https://channels.pantherx.org/git/pantherx-extra.git")
        (branch "rolling")))
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

Also checkout: [Disk usage: Find out where your space goes](https://community.pantherx.org/t/disk-usage-find-out-where-your-space-goes/48)

## Appearance

### Display Scaling

On high resolution screens, it's easy to scale the entire desktop. What works well: 1.25x, 1.5x, 2x.

Find out more: [Scaling on high-resolution screens](https://community.pantherx.org/t/scaling-on-high-resolution-screens/42)

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
