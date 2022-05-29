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

1. Download [pantherx-1.3.0-27.c07910a-image.iso.tar.gz](https://temp.pantherx.org/pantherx-1.3.0-27.c07910a-image.iso.tar.gz) (Beta 6)
2. Extract the ISO

On Linux you can use `tar`:

```bash
tar -xf pantherx-1.3.0-27.c07910a-image.iso.tar.gz
```

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

```bash
$ sudo dd if=pantherx-1.3.0-27.c07910a-image.iso of=/dev/sda status=progress
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

Once you have booted from USB, you will be greeted with "Locale language" selection.

**(1)** Select your locale

{% include snippets/screenshot.html image='installer/install_locale-language.png' %}

**(2)** Select your location

{% include snippets/screenshot.html image='installer/install_location.png' %}

Select "Install using the shell based process".

{% include snippets/screenshot.html image='installer/install_install-using-shell.png' %}

If you're connected via LAN cable, you probably already have internet. Skip ahead to [installation](/Installation-guide/#installation).

### Connect to the Internet

Now that you're in the command like, it should read "Welcome to the Installation of PantherX OS!". Before you continue, you need to establish a internet connection. If you are connected with a LAN cable, that might already have happened.

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

To configure wireless networking, create a configuration file for the wpa_supplicant configuration tool:

```bash
$ nano wpa_supplicant.conf
```

with the following content:

```
network={
  ssid="YOUR_WIFI_NAME"
  key_mgmt=WPA-PSK
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

If the wlan interface is blocked, you can unblock it with `sudo rfkill unblock wlan`. You should run `wpa_supplicant -c ...` after you unblock the device.

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
_Pro-Tip: [Download and run the latest installer](https://git.pantherx.org/development/applications/px-install#debugging)_
</small>

We have come-up with a simple installer that automates all steps. You can go ahead with the defaults (username: `pantherx`) with:

```bash
px-install
```

or customize username, password and so on with:

{% include snippets/screenshot.html image='installer/install_px-install-run.png' alt="" %}

```bash
px-install run
```

{% include snippets/screenshot.html image='installer/install_px-install-approve.png' alt="" %}

Once the installation has completed, it should read something like this:

```bash
guix system: bootloader successfully installed on /dev/sda
```

Now simply reboot with

```bash
reboot
```

- _You can find out more about px-install at [git.pantherx.org/published/px-install](https://git.pantherx.org/published/px-install_pub)._
- _Tip: SSH is disabled by default on Desktop so you won't be able to reconnect after reboot without enabling it first_

## Post-installation

{% include snippets/screenshot.html image='installer/install_login-screen.png' alt="" %}

Once you login for the first time, there's a couple of things to be aware of.

### General

We've put together a welcome screen that guides you trough the essentials:

{% include snippets/screenshot.html image='installer/install_welcome-screen.png' alt="" %}

##### **(1.1)** Set new user and root password

You will be prompted for your desired user and root (administrator) password.

{% include snippets/screenshot.html image='installer/install_welcome-screen-set-password.png' alt="" %}

Once you confirm, you will be prompted for the password you set during the installation, to confirm the change. This should be the same password you used to login.

{% include snippets/screenshot.html image='installer/install_welcome-screen-set-password-confirm.png' alt="" %}

##### **(1.2)** Update your system (opens Software; then just click "Update")

{% include snippets/screenshot.html image='installer/install_welcome-screen-software-update.png' alt="" %}

You will be prompted for your new user password to confirm.

This will take a while; In the meantime you can confirm your (2) Syncthing and (3) Albert configuration.

**Once the update is completed, the buttons (Updating..., Cancel), will return to "UPDATE ALL"**. As this happens, you can close Software.

##### **(1.3)** Changing the theme (dark/bright)

You have the option to stick with the default, dark theme or switch to a bright theme.

##### **(1.4)** Reboot

After you confirm the update (1.2) has completed, you can reboot your system.

### Syncthing

_Free, unlimited, 100% private Dropbox alternative._

{% include snippets/screenshot.html image='installer/install_syncthing-tray-first-run.png' alt="" %}

You will be promted to setup Syncthing, a powerful, decentralized file sharing utility that will replace your Dropbox account by tomorrow.

{% include snippets/screenshot.html image='installer/install_syncthing-tray-setup.png' alt="" %}

1. Open the Settings
2. Go to "Tray" (left sidebar) and look for the tab "Connection"
3. Click "Insert values from local Syncthing configuration"
4. Select "Connect automatically on startup"
5. Confirm with "Apply"

Whenever you want to activate Syncthing, just click on the traybar icon (grayed out circle) and click "Continue".

### Albert

_Very useful quick-launcher to open applications and control your system._

{% include snippets/screenshot.html image='installer/install_albert-first-run.png' alt="" %}

You will be promted to setup Albert; it's an incredibly useful utility that not only helps you launch apps, but does calculations, plays music - really whatever you want.

{% include snippets/screenshot.html image='installer/install_albert-set-hotkey.png' alt="" %}

### PantherX Hub

**You should do this after update and reboot**

If you want to use Hub, you need to setup a account first.

1. Open 'Settings' > 'Online Accounts'
2. Add a account

Hub currently supports GitLab, GitHub, Email (via ClawsMail), Discourse and Mastodon notifications. This list will expand in the coming months.

## Get Help

This is a beta release, so please keep a few things in mind:

- We do not accept bug reports at this time
- We have limited or no time to provide support
- We try to release updates on a 2-week basis

With that being said, we are working exclusively on PantherX OS and I myself do virtually everything on the system without any major issues. In fact, after years on MacOS and the months on various other Linux distributions, I have found PantherX to be much more reliable. If you do ever run into any issues after an update, simply reboot and roll-back your system - in literally 1 second.

**Have a great time on PantherX OS**

{% include snippets/screenshot.html image='installer/start-customizing.png' alt="" %}

### Forum

We encourage you to look around the Wiki and go to [community.pantherx.org](https://community.pantherx.org/) to seek help from the community.
