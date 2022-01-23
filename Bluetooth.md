---
namespace: bluetooth
description: "Bluetooth is a short-range wireless technology standard that is used for exchanging data between fixed and mobile devices over short distances using UHF radio waves in the ISM bands, from 2.402 GHz to 2.48 GHz, and building personal area networks. It was originally conceived as a wireless alternative to RS-232 data cables."
description-source: "https://en.wikipedia.org/wiki/Bluetooth"
categories:
  - type:
      - "Interface"
  - location:
      - "Development"
      - "Virtualization"
language: en
---

On PantherX Desktop Bluetooth is enabled by default from Beta 6.

## Management

## Troubleshooting

### Unable to connect to Bluetooth Device

If you're unable to connect to a new or existing Bluetooth device, there are several things you can try:

#### Suggestion 1:

Restart the Bluetooth service.

Switch to **root** and restart the service:

```bash
su - root
herd restart bluetooth
```

Double-check the service is running:

```bash
$ herd status bluetooth
Status of bluetooth:
  It is started. # <---- look for this
  Running value is 836.
  It is enabled.
  Provides (bluetooth).
  Requires (dbus-system udev).
  Conflicts with ().
  Will be respawned.
```

If the service has restarted successfully, the Bluetooth icon should re-appear on your desktop.

#### Suggestion 2:

If that did not work and the device is already paired:

1. On your Desktop, right-click on the Bluetooth icon in the lower right corner
2. Select "Devices"
3. Find your paired device in the list and remove it
4. (Optional) Follow _Suggestion 1_
5. Try to connect again

## Development

### Test Bluetooth LE Service Discovery

Download `nRF Connect` (Nordic Semiconductor ASA) on your mobile phone.

Once you're in the app, add a new service (Devices / Advertiser):

1. Press the red "+"
2. You should see a prompt: "New advertising packet"
   - Display name can be whatever; `Heart beat`
   - ADD RECORD:
     - Service Data (The data we'll be sending; a heart beat measurement)
   - UUID or service name: `2A37` (0x2A37) [source](https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf)
   - Data (HEX): 0x`4C`
   - ADD RECORD:
     - Service Name (The type of service; heart monitor)
   - UUID `180D` (0x180D) [source](https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf)
3. Confirm with OK and activate

#### Confirm it's working

##### from Desktop

On your desktop, open a Terminal:

1. Run `bluetoothctl`
2. Start a scan with `scan on` (just type this in the terminal)
3. Look out for the values you're advertising

```
# You may have to install `bluez` to your profile with `guix package -i bluez`
$ bluetoothctl
Agent registered
[MX Anywhere 2S]
# scan on
Discovery started
[CHG] Controller 94:E6:F7:0A:43:F7 Discovering: yes
[NEW] Device 25:06:D7:1A:1D:34 25-06-D7-1A-1D-34
[NEW] Device 62:C5:A0:8D:1E:0C 62-C5-A0-8D-1E-0C
[CHG] Device 4B:1A:0F:BF:02:84 ManufacturerData Key: 0x004c
[CHG] Device 4B:1A:0F:BF:02:84 ManufacturerData Value:
  0f 05 80 35 64 d3 c6 10 03 6e 0e bb              ...5d....n..
[NEW] Device 3A:76:AA:3B:43:29 3A-76-AA-3B-43-29
```

##### with a 2nd phone

Download `nRF Connect` (Nordic Semiconductor ASA) on your 2nd mobile phone.

Once you're in the app, look for "Scanner" and "Scan":

1. Look for your device; in our case "Heart Monitor"
   - This name is set automatically from the above service definitions
   - Services should correctly list "Heart Rate"

## See also

- [Docker Service (guix.gnu.org)](https://guix.gnu.org/manual/en/html_node/Miscellaneous-Services.html#Docker-Service)
