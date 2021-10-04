---
---

## Desktop

This provides the default desktop environment.

- Standard Linux kernel
- Firewall with sane defaults (`22` is not open)

```
px-desktop-os
%px-desktop-packages
%px-desktop-services
```

### Example

**Desktop: Boot in BIOS mode**

```scheme
{% include config-examples/base-desktop.scm %}
```

**Desktop: Boot in BIOS mode (with Docker configured)**

```scheme
{% include config-examples/base-desktop-docker.scm %}
```

**Desktop: Boot in EFI mode**

```scheme
{% include config-examples/base-desktop-efi.scm %}
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

## Desktop Libre

This provides the default desktop environment with non-libre components stipped.

- Libre kernel
- Firewall with sane defaults (`22` is not open)

```
px-desktop-os
%px-desktop-packages
%px-desktop-services
```

You can toggle the libre kernel in `system.scm`:

```scheme
(px-desktop-os
  ...
  #:kernel 'nonlibre
)
```

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

## See also

- [Guix Manual: Using the Configuration System](https://www.gnu.org/software/guix/manual/en/html_node/Using-the-Configuration-System.html)
