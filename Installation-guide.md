---
---

You will occasionally see a `$` before a command. This is mostly to differentiate the input (what you type), from the output, the computer provides.

Here's an example:

```bash
$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda             8:0    0 465.8G  0 disk
└─sda1          8:1    0 465.8G  0 part  /media/franz/4e619844-b92a-49bd-8b70-cf934abdc8eb
```

So the actual command is `lsblk` (you don't write `$`).

On the other hand, if there's only a command, and no output, we sometimes omit the `$` like so:

```bash
lsblk
```

## Pre-installation

Before you get started, ready a USB stick with the latest ISO image.

Download [{{ site.iso_title }}]({{ site.iso_url }}) ({{ site.iso_size }})
<br/><code>{{ site.iso_hash }}</code>

#### Flash with dd

Plugin the USB stick and determine the name:

```bash
$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda             8:0    1  14.9G  0 disk
├─sda1          8:1    1     1G  0 part  /media/franz/GUIX_IMAGE
└─sda2          8:2    1   2.8M  0 part
nvme0n1       259:0    0 953.9G  0 disk
├─nvme0n1p1   259:1    0   549M  0 part  /boot/efi
└─nvme0n1p2   259:2    0 953.3G  0 part
  └─cryptroot 253:0    0 953.3G  0 crypt /
```

In my case, it's `/dev/sda`, so I proceed with copying the ISO to this drive:

{% capture new_var %}if={{ site.iso_title }}{% endcapture %}

```bash
$ sudo dd {{ new_var }} of=/dev/sda status=progress
Password:
1110499840 bytes (1.1 GB, 1.0 GiB) copied, 284 s, 3.9 MB/s
2169320+0 records in
2169320+0 records out
1110691840 bytes (1.1 GB, 1.0 GiB) copied, 284.985 s, 3.9 MB/s
$ sync
```

Now un-mount / eject the drive:

```
sudo umount /dev/sda1
```

#### Flash with etcher

If you prefer a GUI tool that runs on your existing OS (Windows, MacOS, other Linux), have a look at [etcher](https://github.com/balena-io/etcher/releases).

### First steps

Now just plugin the USB stick into the target computer, and boot from it. Most commonly, you can get a boot device selection with `F11`.

_Here's what a typical installation looks like: [youtube.com/watch?v=fK2Rx9MKLqw](https://www.youtube.com/watch?v=fK2Rx9MKLqw)._

Once you have booted from USB, you will be greeted with "Locale language" selection.

**(1)** Select your locale

{% include snippets/screenshot.html image='installer/install_locale-language.png' %}

**(2)** Select your location

{% include snippets/screenshot.html image='installer/install_location.png' %}

Select "Install using the shell based process".

{% include snippets/screenshot.html image='installer/install_install-using-shell.png' %}

If you're connected via LAN cable, you probably already have internet. Skip ahead to [installation](/Installation-guide/#installation).

### Connect to the Internet

Now that you're in the command line, it should read "Welcome to the Installation of PantherX OS!". Before you continue, you need to establish a internet connection. If you are connected with a LAN cable, that might already have happened.

Here's how you verify whether you're connected:

```bash
$ px-install network-check
------
Welcome to PantherX Installation v0.0.30

For guidance, consult: https://wiki.pantherx.org/Installation-guide
For help, visit https://community.pantherx.org
------

######## RESULT ########
Found 1 suitable network adapters

1. Adapter
Name: enp2s0
State: UP
Address: | IP: 192.168.1.73  Broadcast: 192.168.1.255 | IP: fe80::6e4b:90ff:feed:9578  Broadcast: None

You appear to be online.
Run 'px-install run' to continue with the setup.
```

One of the listed interfaces, should have a valid IP address. For example `192.168.1.69`. If that's the case, you can proceed to the next step. If not, here's how you connect:

**Either LAN or WLAN must be working before you can proceed**. Here's how you configure either:

#### Wired Network (LAN)

To configure a wired network run the following command, substituting interface with the name of the wired interface you want to use:

```bash
$ ifconfig INTERFACE_NAME up # for ex. enp2s0
```

Now try to get a IP address:

```bash
$ dhclient -v INTERFACE_NAME # for ex. enp2s0
```

#### Wireless Network (WLAN)

_Try our new `px-install wifi-setup`, or configure manually:_

To configure wireless networking, create a configuration file for the wpa_supplicant configuration tool:

```bash
$ nano wpa_supplicant.conf
```

with the following content:

```
network={
  ssid="YOUR_WIFI_NAME"
  key_mgmt=SECURITY_STANDARD
  psk="YOUR_WIFI_PASSWORD"
}
```

once you're done, this should look roughly like this:

```
network={
  ssid="MyWirelessNetwork"
  key_mgmt=WPA-PSK
  psk="3295e09f-241b-4a06-a492-f3f3cc95c24d"
}
```

_You can find more examples and options here: [wpa_supplicant.conf: Linux man page](https://linux.die.net/man/5/wpa_supplicant.conf)._

To start the wireless service, and run it on _interface_ in the background:

```bash
$ wpa_supplicant -c wpa_supplicant.conf -i INTERFACE_NAME -B

# Example
$ wpa_supplicant -c wpa_supplicant.conf -i enp2s0 -B
```

**Note** If this doesn't work, you might want to try to check your network with rfkill:

```bash
$ rfkill
ID TYPE      DEVICE                   SOFT      HARD
 0 bluetooth tpacpi_bluetooth_sw unblocked unblocked
 1 bluetooth hci0                unblocked unblocked
 2 wlan      phy0                unblocked unblocked
```

If the wlan interface is blocked, you can unblock it with `rfkill unblock wlan`.

Now try to get a IP address:

```bash
$ dhclient -v INTERFACE_NAME

# Example
$ dhclient -v wlan0
```

### SSH access (OPTIONAL)

If you want to continue with the installation remotely, load the SSH server and set a _root_ password:

```bash
$ herd start ssh-daemon
Service ssh-daemon has been started.
$ passwd
New Password:
Retype new password:
passwd: password updated successfully
```

Now simply connect via SSH from another computer: `ssh root@192.168.1.67`.

## Installation

<small>
It is highly recommended to download and run the latest version of the installer, instead of the included version: [Download and run the latest installer](https://git.pantherx.org/development/applications/px-install#debugging)
</small>

We have come-up with a simple installer that automates all steps. You can go ahead with the defaults (username: `pantherx`) with:

```bash
px-install
```

or customize username, password and so on with:

```bash
px-install run
```

{% include snippets/screenshot.html image='installer/install_px-install-run.png' alt="" %}

In the latest release, you can select from 4 desktop environments:

- XFCE
- MATE
- Gnome
- LXQt

{% include snippets/screenshot.html image='installer/install_px-install-approve.png' alt="" %}

Once the installation has completed, it should read something like this:

```bash
guix system: bootloader successfully installed on /dev/sda
```

Now simply reboot with

```bash
reboot
```

- _You can find out more about px-install at [git.pantherx.org/development/applications/px-install](https://git.pantherx.org/development/applications/px-install)._
- _Tip: SSH is disabled by default on Desktop so you won't be able to reconnect after reboot without enabling it first_

## Post-installation

{% include snippets/screenshot.html image='installer/install_login-screen.png' alt="" %}

1. Set a new password

```bash
sudo su - root
passwd # for root
passwd panther # for panther user (or your own username)
```

If you did not set a password, the default is `pantherx`.

2. Update the system

You'll want to update both system and user profile. To speed this up by 2x, you can usually do this in parralel, in two tabs (your user, root):

```bash
px update apply
```

3. Reboot and enjoy

**Have a great time on PantherX OS**

Notes:

- You can update your system automatically: [Unattended Upgrades](/Unattended-Upgrades/)