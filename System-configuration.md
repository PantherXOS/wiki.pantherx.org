---
---

PantherX comes with a really easy, command-line based installer that asks virtually no questions. Simply boot the ISO, make sure you're connected to the internet and run [`px-install`](/Installation-guide/#installation).


Also checkout our new [System Configuration Generator](https://www.pantherx.org/configs/).

## Minimal

### Example

**Desktop: Boot in BIOS mode**

```scheme
{% include config-examples/base.scm %}
```

## Desktop

This provides the default desktop environment.

- Standard Linux kernel
- Bluetooth enabled by default

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

**Desktop: Boot in UEFI mode**

```scheme
{% include config-examples/base-desktop-efi.scm %}
```

_For Firewall and SSH configuration, check the previous section. It's identical for every system._

## See also

- [Guix Manual: Using the Configuration System](https://www.gnu.org/software/guix/manual/en/html_node/Using-the-Configuration-System.html)
