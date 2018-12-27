# Installation

## Global Installation

Open and edit your system configuration:

```bash
$ nano /etc/config.scm
```

Make the following changes:

```scheme
;; This is an operating system configuration template
;; for LXQt Desktop with openbox and X11 display server.

(use-modules (gnu) (gnu system nss))
(use-service-modules desktop ssh)
(use-package-modules ssh certs tls version-control lxqt suckless)

(operating-system
  (host-name "panther")
  (timezone "Asia/Tehran")
  (locale "en_US.utf8")

  ;; Boot in "legacy" BIOS mode, assuming /dev/sdX is the
  ;; target hard disk, and "my-root" is the label of the target
  ;; root file system.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (target "/dev/sda")))
  (file-systems (cons (file-system
                        (device (file-system-label "my-root"))
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (cons (user-account
                (name "panther")
                (comment "default")
                (group "users")
                (supplementary-groups '("wheel"
                                        "audio" "video"))
                (home-directory "/home/panther"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons* dmenu lxqt liblxqt ;; window managers
                   openssh nss-certs gnutls
                   git
                   %base-packages))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (cons* (service openssh-service-type
                            (openssh-configuration
                              (port-number 22)))
                   %desktop-services))

  (name-service-switch %mdns-host-lookup-nss))
```

To reconfigure your system, based on the modified configuration, run:

```bash
$ guix system reconfigure /etc/config.scm
```

**Note:** Due to a bug, the default desktop configuration, is not available initially.

To Fix this issue, prepare 2 new directories:

```bash
$ mkdir .config/openbox
$ mkdir .config/lxqt
```

Now populate them with the example, from the reference:

`.config/lxqt/lxqt.conf` with [ref](https://github.com/lxqt/lxqt-session/blob/master/config/lxqt.conf)  
`.config/lxqt/session.conf` with [ref](https://github.com/lxqt/lxqt-session/blob/master/config/session.conf)

# Starting the desktop

## Using xinit

## Graphical login

# Configuration

## Use a different window manager

## Autostart

## Set-up environment variables

## Editing the Application Menu

# Troubleshooting

## Desktop icons are grouped together

# Tips and tricks

## Customizing Leave

# See also
