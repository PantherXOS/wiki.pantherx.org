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
guix package -i qemu
```

## Create a Debian virtual machine

### Create disk

```bash
qemu-img create -f qcow2 debian.qcow 8G
```

### Boot from ISO

```bash
wget https://cdimage.debian.org/cdimage/release/10.5.0/amd64/iso-cd/debian-10.5.0-amd64-netinst.iso
qemu-system-x86_64 -hda debian.qcow -cdrom debian-10.5.0-amd64-netinst.iso -boot d -m 512
```

Install and configure as desired. For this guide, we assume user `root` and `panther`.

After the installation has completed, shutdown the virtual machine.

### Boot from HDD after install

```bash
qemu-system-x86_64 -hda debian.qcow -m 1024
```

### Mount a shared folder

_Source: [pilona: StackExchange](https://superuser.com/a/628381)_

You essentially boot the VM, with the shared folder "attached". if your VM is already booted, shutdown first.

```
-virtfs local,path=$QEMU_SHARE,mount_tag=host0,security_model=none,id=host0
```

This is what it looks like:

```
export QEMU_SHARE=/home/franz/shared_folder
qemu-system-x86_64 -hda debian.qcow -m 1024 -virtfs local,path=$QEMU_SHARE,mount_tag=host0,security_model=none,id=host0
```

Now that Debian is running...

Login as panther and create the shared folder:

```bash
mkdir shared
```

and mount it:

```
sudo mount -t 9p -o trans=virtio,cache=none,rw host0 /home/panther/shared -oversion=9p2000.L -oaccess=user
```

_If you don't have `sudo` installed, you can also login as root with `su - root`.

### Port forwarding

This is especially useful to access the virtual machine SSH, or any running application.

```
-device e1000,netdev=net0 \
-netdev user,id=net0,hostfwd=tcp::2222-:22 \
```

### Bonus: Development setup

If we combine this with the shared folder, we have a flexibe setup for development:

``` 
export QEMU_IMAGE=/home/franz/virtual/debian_jekyll.qcow
export QEMU_SHARE=/home/franz/shared_folder
qemu-system-x86_64 -hda $QEMU_IMAGE -m 1024 \
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
