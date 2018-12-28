---
---

## Pre-installation

### Verify signature

### Boot the live environment

### Set the keyboard layout

To set the keyboard layout:

```bash
$ loadkeys dvorak
```

To list available keyboard layouts, refer to `/run/current-system/profile/share/keymaps` or run `man loadkeys`.

### Connect to the Internet

Find available network interfaces:

```bash
$ ifconfig -a
```

#### Wired Network

To configure a wired network run the following command, substituting interface with the name of the wired interface you want to use:

```bash
$ ifconfig interface up
```

#### Wireless Network

To configure wireless networking, create a configuration file for the wpa_supplicant configuration tool:

```bash
$ nano wpa_supplicant.conf
```

with the following content, substituting your network details:

```
network={
  ssid="my-ssid"
  key_mgmt=WPA-PSK
  psk="the network's secret passphrase"
}
```

To start the wireless service, and run it on _interface_ in the background:

```bash
$ wpa_supplicant -c wpa_supplicant.conf -i interface -B
```

#### Get IP

To get a new IP on your _interface_:

```bash
$ dhclient -v interface
```

### Update the system clock

### Partition the disks

### Format the partitions

### Mount the file systems

## Installation

### Select the mirrors

### Install the base packages

## Configure the system

### Fstab

### Chroot

### Time zone

### Localization

### Network configuration

### Initramfs

### Root password

### Boot loader

## Reboot

## Post-installation
