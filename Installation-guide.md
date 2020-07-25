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

To list available keyboard layouts, refer to `/run/current-system/profile/share/keymaps` or run `man loadkeys`. By default, the installation uses _US qwerty_.

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

##### Using WPA-Supplicant

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

##### Using Connman

another tool that is available on installation iso is `connman` service and  we
can configure that using `connmanctl`. in order to connect to wifi networks using
`connmanctl`, first we need to unblock `wifi` module using:

```shell
root@gnu ~# rfkill unblock wifi
```

now we can connect to wifi networks using `connmanctl`:

```shell
root@gnu ~# connmanctl
connmanctl> scan wifi
connmanctl> services
SSID-1   wifi_...._......
SSID-2   wifi_...._......
SSID-3   wifi_...._......
SSID-4   wifi_...._......
SSID-5   wifi_...._......
...
connmanctl> agent on
connmanctl> connect wifi_...
```

#### Get IP

To get a new IP for your _interface_:

```bash
$ dhclient -v interface
```

### SSH access

If you want to continue with the installation remotely, load the SSH server and set a _root_ password:

```bash
$ herd start ssh-daemon
$ passwd
```

### Partition the disks

First we'll need to create at least one partition:

```bash
$ cfdisk
```

**For a very basic set-up, go with**

- dos
- new
- keep size
- primary
- write - yes
- quit

### Format the partitions

To format the new partition, use:

```bash
$ mkfs.ext4 -L my-root /dev/sda1
```

#### swap space

If you've also created a _swap_ partition _sda2_, format and enable it now:

```bash
$ mkswap /dev/sda2
$ swapon /dev/sda2
```

Alternatively, you may create a _swap_ file:

```bash
$ dd if=/dev/zero of=/mnt/swapfile bs=1MiB count=10240
# For security, we allow only root to read / write the swap file
$ chmod 600 /mnt/swapfile
$ mkswap /mnt/swapfile
$ swapon /mnt/swapfile
```

### Mount the file systems

```bash
$ mount LABEL=my-root /mnt
```

## Installation

```bash
herd start cow-store /mnt
```

### Configure the system

```bash
$ mkdir /mnt/etc
# System configuration examples are below
$ nano /mnt/etc/system-config.scm
```

Once you're satisfied with your configuration, proceed with the installation:

```bash
$ guix system init /mnt/etc/system-config.scm /mnt
```

#### System configuration

##### Bare bones example

```scheme
{% include config-examples/bare-bones.scm %}
```

##### GNOME example

```scheme
{% include config-examples/gnome.scm %}
```

##### Xfce example

```scheme
{% include config-examples/xfce.scm %}
```

Read more about [System Configuration](/System-configuration/) and discover countless of other examples.


#### Touchpad Tap to click Activation
To activation tap to click you can add an extra config to `xorg-configuration` in `sddm-service-type` part:

```scheme
         (service sddm-service-type
             (sddm-configuration
               (minimum-uid 1000)
               (theme "darkine")
               (xorg-configuration
                 (xorg-configuration
                   (extra-config `("Section \"InputClass\"\n"
                                   "   Identifier \"touchpad\"\n"
                                   "   Driver \"libinput\"\n"
                                   "   MatchIsTouchpad \"on\"\n"
                                   "   Option \"Tapping\" \"on\"\n"
                                   "EndSection\n"
                                   "\n"))))))
```

## Reboot

After completion, you may boot into your new system with `reboot`.

## Post-installation

To proceed, it's best you login with _root_.

### Root password

Set the _root_ password with:

```bash
$ passwd
```

### User password

Set the _username_ password with:

```bash
$ passwd username
```

### Update the system

It's good practice to update the system now:

```bash
$ guix pull
```

This will download the latest package definitions, and update _guix_ itself. To apply the update, do:

```bash
$ guix system reconfigure /etc/system-config.scm
```

Once that has completed, restart your system:

```bash
$ reboot
```

After rebooting, you can list your system generations with:

```bash
$ guix system list-generations
```

After a fresh installation, and first update, you should see 2 generations, similar to this:

```bash
Generation 1	Dec 07 2018 23:20:14
  file name: /var/guix/profiles/system-1-link
  canonical file name: /gnu/store/sfk9hvzlxppgbkp1rql1d9r7gv3zrj4a-system
  label: GNU with Linux-Libre 4.19.6 (beta)
  bootloader: grub
  root device: label: "my-root"
  kernel: /gnu/store/0zajbn9q39yva4l0zzrcshlll8qikzba-linux-libre-4.19.6/bzImage
Generation 2	Dec 08 2018 11:36:15
  file name: /var/guix/profiles/system-2-link
  canonical file name: /gnu/store/5q7i7wg2smfyfkzdkgi0na2xl8c6yz21-system
  label: GNU with Linux-Libre 4.19.6 (beta)
  bootloader: grub
  root device: label: "my-root"
  kernel: /gnu/store/0zajbn9q39yva4l0zzrcshlll8qikzba-linux-libre-4.19.6/bzImage
```

Every time you make a change to your system configuration, with `guix system reconfigure ...`, a new system generation will be initiated. If anything ever goes wrong, you can roll-back to a previous generation _1_ with:

```bash
$ guix system switch-generation 1
```

This _switch_ is also available trough _grub_, so you can roll-back, without command line access.
