---
---

PantherX comes with a really easy, command-line based installer that asks virtually no questions. Simply boot the ISO, make sure you're connected to the internet and run [`px-install`](/Installation-guide/#installation).


Also checkout our new [System Configuration Generator](https://www.pantherx.org/configs/).

## Desktop

This provides the default desktop environment.

- Standard Linux kernel
- Firewall with sane defaults (`22` is not open)

```
px-desktop-os
%px-desktop-packages
%px-desktop-services
```

You can configure any of the available guix desktops:

- `xfce-desktop-service-type`
- `mate-desktop-service-type`
- `gnome-desktop-service-type`
- `lxqt-desktop-service-type`

If you have a modern PC, you will probably want to use UEFI: Skip ahead to "Desktop: Boot in UEFI mode"

### Example

**Desktop: Boot in BIOS mode**

```scheme
{% include config-examples/base-desktop.scm %}
```

**Desktop: Boot in BIOS mode (with Docker configured)**

```scheme
{% include config-examples/base-desktop-docker.scm %}
```

**Desktop: Boot in UEFI mode**

```scheme
{% include config-examples/base-desktop-efi.scm %}
```

### Adjust Firewall

PantherX defaults to `nftables` as package filter and as seen above, it's easy to open additional ports.

Example for SSH:

```scheme
#:open-ports '(("tcp" "ssh"))
```

Example for typical webserver:

```scheme
#:open-ports '(("tcp" "ssh", "http", "https"))
#:open-ports '(("tcp" "22", "80", "443")) ;; identical
```

Example with multiple protocols:

```scheme
#:open-ports '(("tcp" "ssh")
               ("udp" "53"))
```

### Enable SSH access

To access your desktop remotely:

1. Define your public key in config.scm
2. Open the SSH port
3. Add your public key to the authorized keys

```scheme
(define %ssh-public-key
  "ssh-ed25519 AAAAC3NzaC1lZSJANJQ5AAAAIP7gcASKK1KAM91dl1OC0GqpgcudsaaJ4QydPg panther")

(px-desktop-os
  ...
  #:open-ports '(("tcp" "ssh"))
  #:authorized-keys `(("root" ,(plain-file "panther.pub" %ssh-public-key))
))
```

### Change Kernel

`px-desktop-os` defaults on `nonlibre` kernel, `px-server-os` on `libre`.

You can easily switch between kernel:

- `#:kernel 'libre`
- `#:kernel 'nonlibre`
- `#:kernel 'custom`

If needed, `'custom` gives you fill control:

```scheme
(px-desktop-os
  (operating-system
    ...
    (kernel linux)
      (initrd microcode-initrd)
      (firmware (list linux-firmware))
	...
))
```

## Desktop Libre

This provides the default desktop environment with non-libre components stripped.

- Libre kernel
- Firewall with sane defaults (`22` is not open)

Use this only if you know what you're doing.

```
px-desktop-os
%px-desktop-packages
%px-desktop-services
```

You can toggle the libre kernel in `system.scm`:

```scheme
(px-desktop-os
  ...
  #:kernel 'libre
)
```

_For Firewall and SSH configuration, check the previous section. It's identical for every system._

## Server

This provides the default server environment.

- Libre kernel
- Firewall with sane defaults (`22` is open)
- SSH login only with SSH key
- DHCP, NTP

```scheme
px-server-os
%px-server-packages
%px-server-services
```

### Example

**Server: Boot in BIOS mode**

```scheme
{% include config-examples/base-server.scm %}
```

_For Firewall and SSH configuration, check the previous section. It's identical for every system._

## See also

- [Guix Manual: Using the Configuration System](https://www.gnu.org/software/guix/manual/en/html_node/Using-the-Configuration-System.html)
