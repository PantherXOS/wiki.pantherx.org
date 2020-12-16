---
namespace: VPN
description: Notes about using a virtual private network on PantherX
categories:
  - type:
    - "Guide"
  - location:
  - "vpn"
  - "Desktop"
language: en
---

## WireGuard

_Tip: Before you get started, note your current public IP with `curl https://my-ip.pantherx.org`._

### Mullvad

Generate a WireGuard configuration in your [Mullvad account (https://mullvad.net/en/account/#/wireguard-config/)](https://mullvad.net/en/account/#/wireguard-config/):

1. Select "Linux"
2. Generate a WireGuard key
3. Select one exit location (ex. Germany, Frankfurt, de12-wireguard)
4. Download file

You now have a `mlvd-de12.conf` in your _Downloads_ folder and two options:

1. Import to Network Manager (connects automatically; reconnects on reboot)
2. Run manually via `wg-quick`

To import to Network Manager, do:

```bash
$ nmcli connection import type wireguard file mlvd-de12.conf
```

That's it! To verify you're connected, you can do one of two (many) things:

1. Run `ip address` and look for `mlvd-de12`.
   - verify that an IP has been assigned: ex. `inet 10.**.**.**/32`
   - check whether your public IP has changed: `curl https://my-ip.pantherx.org`
2. Check Mullvad's own "Connection Check" [here (https://mullvad.net/en/check/)](https://mullvad.net/en/check/)
3. Run `nmcli` and ensure that: `mlvd-de12: connected to mlvd-de12`

To remove this connection, simply run:

```bash
$ nmcli connection delete mlvd-se8
Connection 'mlvd-se8' (acf9afff-d380-4d86-99b9-529a8b5c76ef) successfully deleted.
```

## See also

- [WireGuard in NetworkManager](https://blogs.gnome.org/thaller/2019/03/15/wireguard-in-networkmanager/)
