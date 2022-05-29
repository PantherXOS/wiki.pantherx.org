---
---

You will ocassionally see a `$` before a command. This is mostly to differentiate the input (what you type), from the output, the computer provides.

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

Now unmount / eject the drive:

```
sudo umount /dev/sda1
```

#### Flash with etcher

If you prefer a GUI tool that runs on your existing OS (Windows, MacOS, other Linux), have a look at [etcher](https://github.com/balena-io/etcher/releases).

### First steps

Now just plugin the USB stick into the target computer, and boot from it. Most commonly, you can get a boot device selection with `F11`.

Once you have booted from USB, you will be greeted with "Locale language" selection.

1. Select your locale
2. Select your region

The graphical installation is not quite ready yet, so we'll proceed manually.

Select "Install using the shell based process".

### Connect to the Internet

Now that you're in the command like, you should read "Welcome to the Installation of PantherX OS!". Before we get continue, we need to establish a internet connection. If you are connected with a LAN cable, that might already have happened.

Here's how you verify whether you're connected:

```bash
$ ifconfig -a
eno1      Link encap:Ethernet  HWaddr A8:A1:59:5E:FB:D9
          UP BROADCAST MULTICAST DYNAMIC  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0  TX bytes:0
          Interrupt:16 Memory:a1200000-a1220000

enp2s0    Link encap:Ethernet  HWaddr A8:A1:59:5E:FC:A0
          inet addr:192.168.1.69  Bcast:192.168.1.255  Mask:255.255.255.0  # <-- valid IP
          UP BROADCAST RUNNING MULTICAST DYNAMIC  MTU:1500  Metric:1
          RX packets:71 errors:0 dropped:0 overruns:0 frame:0
          TX packets:104 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:12868  TX bytes:19744

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Bcast:0.0.0.0  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:19 errors:0 dropped:0 overruns:0 frame:0
          TX packets:19 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:3485  TX bytes:3485
```

One of the listed interfaces, should have a valid IP address. For example `192.168.1.69`. If that's the case, you can proceed to the next step. If not, here's how you connect:

#### Wired Network (LAN)

To configure a wired network run the following command, substituting interface with the name of the wired interface you want to use:

```bash
$ ifconfig INTERFACE_NAME up

# Example
$ ifconfig enp2s0 up
```

Now try to get a IP address:

```bash
$ dhclient -v INTERFACE_NAME

# Example
$ dhclient -v enp2s0
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
$ dhclient -v enp2s0
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

### Partition and format the disks

Depending on your PC, you should either install with BIOS or EFI support. EFI support is only available on newer PC's, yet BIOS support should always work.

Before you get started, make sure you target the right hard disk:

```bash
$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0 59.6G  0 disk
└─sda1   8:1    0 59.6G  0 part
sdb      8:16   1 14.9G  0 disk
├─sdb1   8:17   1    1G  0 part
└─sdb2   8:18   1  2.8M  0 part
```

In this case, `sda` will be out target disk.

#### BIOS-Boot (OPTION 1)

Let's partition

```bash
cfdisk /dev/sda
```

1. Create a boot partition with the capacity of `2M` and `BIOS Boot` type
2. Create a system partition with the capacity of whatever is remaining (`59.4G`) and `Linux filesystem` (Default)

Make sure that it looks roughly like this:

```
Device			Start			End				Sectors			Size 		Type
/dev/sda1       2048            6143          	4096          	2M 			BIOS boot
/dev/sda2   	6144          	125045390       125039246       59.4G 		Linux filesystem
```

Next, format the second partitions:

```bash
mkfs.ext4 -L my-root /dev/sda2
```

#### EFI-Boot (OPTION 2)

First we need to ensure that the target disk follows the GPT format:

```bash
parted /dev/sda mklabel gpt --script
```

Let's partition

```bash
cfdisk /dev/sda
```

1. Create a boot partition with the capacity of `200M` and `EFI System` type
2. Create a system partition with the capacity of whatever is remaining (`59.4G`) and `Linux filesystem` (Default)

Make sure that it looks roughly like this:

```
Device			Start			End				Sectors			Size 		Type
/dev/sda1       2048            411647          409600          200M 		EFI System
/dev/sda2   	411648          125045390       124633743       59.4G 		Linux filesystem
```

Now set the `esp` flag:

```bash
parted /dev/sda set 1 esp on
```

Next, format the two partitions:

```bash
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -L my-root /dev/sda2
```

and mount the EFI partition at `/boot/efi`

```bash
mkdir /boot/efi
mount /dev/sda1 /boot/efi
```

### Mount the file systems

```bash
mount LABEL=my-root /mnt
```

### Swap space

This is somewhat optional but highly recommended. If your computer runs out of memory (RAM), it can utilize the swap space, to store the data. This is a 1000x times slower than RAM but will prevent your computer from locking-up.

Here's how you create a swap space:

_If you have 4GB of RAM, a count of `4096` (as in 4096 MB) is recommended._

```bash
$ dd if=/dev/zero of=/mnt/swapfile bs=1MiB count=4096
4096+0 records in
4096+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 34.4218 s, 125 MB/s
$ chmod 600 /mnt/swapfile
$ mkswap /mnt/swapfile
Setting up swapspace version 1, size = 4 GiB (4294963200 bytes)
no label, UUID=ea7cc142-1225-48a1-b68d-dd5c9a958938
$ swapon /mnt/swapfile
```

## Installation

Now we're ready to kick-off the actual installation!

```bash
$ herd start cow-store /mnt
Service cow-store has been started.
```

### Configure the system

First we will have to create a folder, to hold our new system configuration:

```bash
$ mkdir /mnt/etc
```

Create the file with:

```bash
$ nano /mnt/etc/system.scm
```

_See Option 1 and 2 below._

You'll need to modify some details:

- `host-name` (px-base): This is what your computer will be called on the network
- `timezone` (Europe/Berlin). You can find a list of all time zones [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

Under users, adapt the user account:

- `name`: This is a one-word, lowercase username such as `franz`
- `home-directory`: should reflect the username: `/home/franz`

#### System configuration BIOS-boot (OPTION 1)

If you followed the bios boot partitioning steps, your system configuration should look like this. **Make sure that you adapt it to your needs!**

You can ignore the other settings for now.

```scheme
{% include config-examples/base-desktop.scm %}
```

#### System configuration EFI-boot (OPTION 2)

Create the file with:

```bash
$ nano /mnt/etc/system.scm
```

If you followed the EFI boot partitioning steps, your system configuration should look like this. **Make sure that you adapt it to your needs!**

You can ignore the other settings for now.

```scheme
{% include config-examples/base-desktop-efi.scm %}
```

#### Channels

Once you've set the system configuration, we put in place the channels in place. These work much like repositories on other Linux distribution... This is where your software comes from!

Create the file with:

```bash
$ mkdir /mnt/etc/guix
$ nano /mnt/etc/guix/channels.scm
```

with the following content:

```scheme
(list (channel
       (name 'guix)
       (url "https://channels.pantherx.org/git/pantherx.git")
       (branch "rolling-nonlibre"))
      (channel
       (name 'nongnu)
       (url "https://channels.pantherx.org/git/nongnu.git")
       (branch "rolling"))
      (channel
       (name 'pantherx)
       (url "https://channels.pantherx.org/git/pantherx-extra.git")
       (branch "rolling")))
```

### Update and install

Once you're satisfied with your configuration, proceed with the installation.

First we'll pull the latest packages:

```bash
$ guix pull --channels=/mnt/etc/guix/channels.scm --disable-authentication
Updating channel 'guix' from Git repository at 'https://channels.pantherx.org/git/pantherx.git'...
receiving objects  37% [####################################################################
...
hint: After setting `PATH', run `hash guix' to make sure your shell refers to `/root/.config/guix/current/bin/guix'.
```

_Initial pull requires `--disable-authentication` to be set. We are working on a solution to rectify the problem. Subsequent pulls, do not require this._

Lastly, run:

```bash
hash guix
```

Once that's done, initiate the system

```bash
$ guix system init /mnt/etc/system.scm /mnt
substitute: updating substitutes from 'https://ci.guix.gnu.org'... 100.0%
substitute: updating substitutes from 'https://bordeaux.guix.gnu.org'... 100.0%
substitute: updating substitutes from 'https://build.pantherx.org'... 100.0%
242.6 MB will be downloaded
 usb-modeswitch-data-20191128  19KiB
 ...
guix system: bootloader successfully installed on '/dev/sda'
```

## Reboot

After completion, `reboot`.

_Tip: SSH is disabled by default on Desktop so you won't be able to reconnect after reboot without enabling it first_

## Post-installation

### First login:

Once you login for the first time, there's a couple of things to be aware of.

#### (1) General

We highly recommend you to run an initial update, before you get started.

1. Open 'System Tools' > 'Terminal'
2. Apply both user and system updates

```bash
px update apply # initial user update
su - root
px update apply # initial root updaye
reboot
```

This will also ensure that you do not run into this issue: [Opening Folders from Directory Menu failed](https://wiki.pantherx.org/LXQt/)

You can take care of 2, 3, 4 while you're waiting for the update to finish.

#### (2) Syncthing

You will be promted to setup Syncthing, a powerful, decentralized file sharing utility that will replace your Dropbox account by tomorrow.

1. Open the Settings
2. Go to "Tray" (left sidebar) and look for the tab "Connection"
3. Click "Insert values from local Syncthing configuration" and confirm with "Apply"

Whenever you want to activate Syncthing, just click on the traybar icon (greyed out circle) and click "Continue".

#### (3) Albert

You will be promted to setup Albert; it's an incredibly useful utility that not only helps you launch apps, but does calculations, plays music - really whatever you want.

#### (4) PantherX Hub

If you want to use Hub, you need to setup a account first.

1. Open 'Settings' > 'Online Accounts'
2. Add a account

Hub currently supports GitLab, GitHub, ClawsMail (Email) and Mastodon. This list will expand in the coming months.

#### (5) Set new user and root password

1. Open 'System Tools' > 'Terminal'
2. Set a root password with `sudo passwd`
3. Set a user password with `passwd YOUR_USERNAME`

## Get Help

This is a beta release, so please keep a few things in mind:

- We do not accept bug reports at this time
- We do not provide support except for occasional forum comments
- We try to release updates on a 2-week basis

With that being said, we are working exclusively on PantherX OS and I myself do virtually everything on the system without any major issues. In fact, after years on MacOS and the months on various other Linux distributions, I have found PantherX to be much more reliable. If you do ever run into any issues after an update, simply reboot and roll-back your system in literally 1 second.

**Have a great time on PantherX OS**

### Forum

We encourage you to look around the Wiki and go to [community.pantherx.org](https://community.pantherx.org/) to seek help from the community.
