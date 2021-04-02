---
namespace: qemu
description: "QEMU is a free and open-source emulator and virtualizer that can perform hardware virtualization."
description-source: "https://en.wikipedia.org/wiki/QEMU"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
   - "Virtualization"
language: en
---

## Installation

```bash
$ guix package -i qemu
```

## Create a (Debian) virtual machine

### Create disk

Before we get started, we need some sort of disk, to store our data:

- `qcow` is a sparse bundle format that grows as you fill it
- `8GB` is the (maximum) size

```bash
$ qemu-img create -f qcow2 debian.qcow 8G
```

### Boot from ISO

We also need a ISO to boot and install from:

```bash
$ wget https://cdimage.debian.org/cdimage/release/10.5.0/amd64/iso-cd/debian-10.5.0-amd64-netinst.iso
```

Now we can boot qemu with the sparse bundle (HDD) and ISO attached:

- `-m 512` is the assigned RAM in Megabyte (512 MB)

```bash
$ qemu-system-x86_64 -hda debian.qcow -cdrom debian-10.5.0-amd64-netinst.iso -boot d -m 512
```

Install and configure as desired. For this guide, we assume user `root` and `panther`.

After the installation has completed, shutdown the virtual machine.

### Boot from HDD after install

```bash
$ qemu-system-x86_64 -hda debian.qcow -m 1024
```

### Mount a shared folder

You essentially boot the VM, with the shared folder "attached". if your VM is already booted, shutdown first.

```bash
-virtfs local,path=$QEMU_SHARE,mount_tag=host0,security_model=none,id=host0
```

This is what it looks like:

```
$ export QEMU_SHARE=/home/franz/shared_folder
$ qemu-system-x86_64 -hda debian.qcow -m 1024 -virtfs local,path=$QEMU_SHARE,mount_tag=host0,security_model=none,id=host0
```

Now that Debian is running...

Login as panther and create the shared folder:

```bash
$ mkdir shared
```

and mount it:

```bash
$ sudo mount -t 9p -o trans=virtio,cache=none,rw host0 /home/panther/shared -oversion=9p2000.L -oaccess=user
```

_If you don't have `sudo` installed, you can also login as root with `su - root`.

### Port forwarding

This is especially useful to access the virtual machine SSH, or any running application.

```bash
-device e1000,netdev=net0 \
-netdev user,id=net0,hostfwd=tcp::2222-:22 \
```

### More performance using KVM

So far, we've been running Qemu as user, and you'll likely notice the weak performance.

To run Qemu with KVM (Kernel Virtual Machine) enabled, you have two options:

1. Run with `sudo` like so:

```bash
$ sudo qemu-system-x86_64 -enable-kvm ....
```

2. Add your user to the `kvm` group, and run without `sudo`, like so:

```lisp
(users (cons (user-account
                 (name "franz")
                 (comment "default")
                 (group "users")
                 ;; Adding the account to the "wheel" group
                 ;; makes it a sudoer.  Adding it to "audio"
                 ;; and "video" allows the user to play sound
                 ;; and access the webcam.
                 (supplementary-groups '("wheel" "netdev"
                                         "audio" "video" "docker" "kvm"))
                 (home-directory "/home/franz"))
               %base-user-accounts))
```

Now you can:

```bash
$ qemu-system-x86_64 -enable-kvm
```

### Attach USB device

It's easy to attach almost any USB device to qemu, including card readers, cameras, phones and hard disks. This is especially useful to work with legacy Windows tools.

1) Find the desired device parameter:

```bash
$ lsusb
Bus 004 Device 003: ID 05e3:0754 Genesys Logic, Inc. USB Storage
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 004: ID 04f2:b67c Chicony Electronics Co., Ltd Integrated Camera
Bus 001 Device 012: ID 17ef:6099 Lenovo Lenovo Traditional USB Keyboard
Bus 001 Device 011: ID 072f:b100 Advanced Card Systems, Ltd ACR39U <----
...
```

2) Now that we have the device name, we simply append that to our qemu start command. Note `Bus 001` becomes `hostbus=1` and `Device 011` becomes `hostaddr=11`.

```bash
-usb -device usb-host,hostbus=1,hostaddr=11
```

You might run into some permission issues, and qemu might throw an error. Here's how-to assign yourself temporary permission, to access the specific device:

```bash
chmod a+w /dev/bus/usb/001/011
```

Here's the full command, booting from qcow image with Windows 7:

```bash
qemu-system-x86_64 \
-enable-kvm \
-hda windows7.qcow -m 2048 \
-usb -device usb-host,hostbus=1,hostaddr=11
```

If you faced with an error like this:

```
qemu-system-x86_64: -device usb-host,hostbus=1,hostaddr=11: failed to open host usb device 1:6
```

you can add `-device qemu-xhci` before `-usb` option:

```bash
qemu-system-x86_64 \
-enable-kvm \
-hda windows7.qcow -m 2048 \
-device qemu-xhci -usb -device usb-host,hostbus=1,hostaddr=11
```

### Access VNC

To enable VNC access to your VNC on local port `5900`, simply append:

```
-vnc :0
```

You should be able to connect to the VM via VNC on `127.0.0.1:5900`.

### Bonus: Development setup

If we combine this with the shared folder, we have a flexibe setup for development:

You'll need to adapt two lines to suit your setup:

- `QEMU_IMAGE=/your/imagefile.qcow`
- `QEMU_SHARE=/your/shared/folder`

```bash
$ export QEMU_IMAGE=/home/franz/virtual/debian_jekyll.qcow
$ export QEMU_SHARE=/home/franz/shared_folder
$ qemu-system-x86_64 -enable-kvm -hda $QEMU_IMAGE -m 1024 \
-device e1000,netdev=net0 \
-netdev user,id=net0,hostfwd=tcp::2222-:22,hostfwd=tcp::4000-:4000 \
-virtfs local,path=$QEMU_SHARE,mount_tag=host0,security_model=none,id=host0
```

In this case, we'd run Jekyll inside the VM. Here's what this will look like:

- Shared folder that hosts the git repository
- SSH port `22` forwarded to `2222` for easy `ssh -p 2222 panther@127.0.0.1`
- Point your browser to `127.0.0.1:4000` to see the result

Tip: You will have to run your application on `0.0.0.0`. 
With jekyll, you can do `jekyll --host 0.0.0.0`.
For jekyll, you might also have to add `--force_polling` for your changes to get picked-up since inotify doesn't work trough p9.

## See also

- [9setup (wiki.qemu.org)](https://wiki.qemu.org/Documentation/9psetup)
