---
namespace: VPN
description: Notes about using a virtual private network
categories:
  - type:
      - "Guide"
  - location:
  - "vpn"
  - "Desktop"
language: en
---

_Tip: Before you get started, note your current public IP with `curl https://my-ip.pantherx.org`._

## WireGuard

### WireGuard via CLI (Mullvad)

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

## OpenVPN

### OpenVPN via GUI (Mullvad)

Generate a OpenVPN configuration in your [Mullvad account (https://mullvad.net/en/account/#/openvpn-config/)](https://mullvad.net/en/account/#/openvpn-config/):

1. Select "Android/Chrome OS"
2. Select Country and City
3. Download file

Add it to Network Manager

Open **Menu** > **Settings** > **Advanced networking** and look for the "+" at the bottom of the screen, to add a new connection

Select "Import a saved VPN configuration"

{% include snippets/screenshot.html image='vpn/ovpn-import-saved.png' alt="Import OpenVPN connection to Network Manager" %}

The username is your Mullvad account number, the password is `m`.

{% include snippets/screenshot.html image='vpn/ovpn-add-username-password.png' alt="Add Mullvad username and password to OpenVPN connection in Network Manager" %}

#### Connect automatically

After you add the connection, you may want to connect to it automatically:

1. Close the OpenVPN config
2. Select the network you wish to associate with the VPN, from the overview
3. Select "Automatically connect to VPN" and the VPN (for ex. `mullvad_se_all`) and save

{% include snippets/screenshot.html image='vpn/ovpn-connect-automatically.png' alt="Automatically connect to OpenVPN with Network Manager" %}

#### Connect manually

Look for Network Manager in the task bar, left click on the icon, and look for "VPN Connections"

{% include snippets/screenshot.html image='vpn/ovpn-connect-manually.png' alt="Manually connect to OpenVPN with Network Manager" %}

### OpenVPN via GUI (iVPN)

Generate a new config here: https://www.ivpn.net/openvpn-config and download and extract it (right click: extract here).

Add it to Network Manager

Open **Menu** > **Settings** > **Advanced networking** and look for the "+" at the bottom of the screen, to add a new connection.

Select "Import a saved VPN configuration" and look for the `.ovpn` file in the folder extracted previously.

The username is your accont ID (‘ivpnXXXXXXXX’ or ‘i-XXXX-XXXX-XXXX’) and any password.

## See also

- [WireGuard in NetworkManager](https://blogs.gnome.org/thaller/2019/03/15/wireguard-in-networkmanager/)
