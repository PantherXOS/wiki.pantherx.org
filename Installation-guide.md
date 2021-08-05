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

Plugin the USB stick and determine the name:

```bash
$ lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda             8:0    0 465.8G  0 disk  
└─sda1          8:1    0 465.8G  0 part  /media/franz/4e619844-b92a-49bd-8b70-cf934abdc8eb             
sdb             8:16   1  14.9G  0 disk                                                                
├─sdb1          8:17   1  14.9G  0 part                                                                
└─sdb2          8:18   1   512K  0 part  /media/franz/UEFI_NTFS                                        
nvme0n1       259:0    0 953.9G  0 disk                                                                
├─nvme0n1p1   259:1    0   549M  0 part  /boot/efi                                                     
└─nvme0n1p2   259:2    0 953.3G  0 part                                                                
  └─cryptroot 253:0    0 953.3G  0 crypt /
```

In my case, it's `/dev/sdb`, so I proceed with copying the ISO to this drive:

```bash
$ sudo dd if=pantherx-1.3.0-5.456b36b-image.iso of=/dev/sdb status=progress                                                                
Password: 
1090949632 bytes (1.1 GB, 1.0 GiB) copied, 270 s, 4.0 MB/s 
2137076+0 records in
2137076+0 records out
1094182912 bytes (1.1 GB, 1.0 GiB) copied, 270.272 s, 4.0 MB/s
$ sync
```

Now just plugin the USB stick into the target computer, and boot from it. Most commonly, you can select to boot from it with `F11`.

### First steps

Once you have booted from USB, you will be greeted with "Locale language" selection.

1. Select the locale (English)
2. Select the region (Ireland)

The graphical installation is not quite ready yet, so we'll proceed manually.

Select "Install using the shell based process".

### Connect to the Internet

Now that you're in the command like, you should read "Welcome to the Installation of PantherX OS!". Before we get continue, we need to establish a internet connection. If you are connected with a LAN cable, that might already have happened.

Here's how you verify whether you're connected:

```bash
$ ifconfig -a
```

One of the listed interfaces, should have a valid IP address. For example `192.168.1.67`. If that's the case, you can proceed to the next step. If not, here's how you connect:

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

TODO

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
$ mount LABEL=my-root /mnt
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
$ nano /mnt/etc/channels.scm
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
$ guix pull --channels=/mnt/etc/channels.scm --disable-authentication
Updating channel 'guix' from Git repository at 'https://channels.pantherx.org/git/pantherx.git'...
receiving objects  37% [#################################################################### 
...
hint: After setting `PATH', run `hash guix' to make sure your shell refers to `/root/.config/guix/current/bin/guix'.
```

_Initial pull requires `--disable-authentication` to be set. We are working on a solution to rectify the problem. Subsequent pulls, do not require this.

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

You should be greeted with a login screen, but you won't be able to login yet.

1. Switch to another TTY with STRG + ALT + F1
2. Login (press enter)
3. Set a root password with `passwd`
4. Set a user password with `passwd YOUR_USERNAME`

Now you can switch back to TTY with STRG + ALT +F7

By the way, good to remember this! If you desktop ever becomes unresponsive, you can always try STRG + ALT + F1, login and `reboot` - or do whatever you have to.

## Miscellaneous Notes:

### Dual Boot

in order to have dual boot on PantherX, we need to add menu entries for other
operating systems to `bootloader` section of system configuration:

```scheme
(bootloader (bootloader-configuration
              ...
              (menu-entries
                (list (menu-entry
                        (label "Arch Linux")
                          (linux "/path/to/vmlinuz-linux")          ; path to vmlinuz-linux, in target partition
                          (linux-arguments '("root=/dev/sdaX"))     ; target partition that tartget os files are located in
                          (initrd "/path/to/initramfs-linux.img"))  ; path to initrd image in target partition
                      ...
                      ))))
```

**Note:** since PantherX linux image and initrd is stored inside *store* and automatically
managed by `guix system`, so for now PantherX should be responsible for management.

[reference](https://guix.gnu.org/manual/en/html_node/Bootloader-Configuration.html)

### Touchpad Tap to click Activation

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
