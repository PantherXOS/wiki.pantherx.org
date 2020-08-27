---
namespace: Virtualization
description: Notes about using virtualization technologies on Guix.
categories:
  - type:
    - "Guide"
  - location:
  - "virtualization"
  - "Desktop"
language: en 
---

## QEMU

### Run as live machine

Using Guix as host, we can generate a shell script that runs Guix based on
a system configuration file. later we can pass QEMU parameters to this generated
script.

```bash
$ guix system vm /path/to/config.scm
...
/gnu/store/...-run-vm.sh
$ /gnu/store/…-run-vm.sh -m 1024 -smp 2 -net user,model=virtio-net-pci
```

running the above script, we have a QEMU instance, that boots to an instance
of Guix defined by our configuration file.

### Prepare permanent disk image

alternatively we can generate a disk image in QCOW2 format, containing Guix
instance installed on match with our provided configuration file.

```bash
$ guix system vm-image /path/to/config.scm
...
/gnu/store/...-qemu-image
```

later we can run this image using `qemu`.

```bash
$ qemu-system-x86_64 \
    -nic user,model=virtio-net-pci \
    -enable-kvm -m 1024 \
    -device virtio-blk,drive=myhd \
    -drive if=none,file=/path/to/...-qemu-image,id=myhd
```

### Notes about running VM

running the disk image there are a series of items that we need to consider:

1. generated disk image will be saved in `store`, and since store is a read-only
   location, we need to copy that to some other place and assign write permission
   before we can use generated image.

2. default image generated using `guix system vm-image` usually doesn't have
   enough space for additional files and packages to store/install. so if we
   need more space, we should pass our desired size using `--image-size`
   parameter.

   ```bash
   guix system vm-image /path/to/config.scm --image-size 10G
   ```

3. in order to have ssh access to the virtual machine, we need to forward
   default ssh port of the guest machine to some other port in host
   using `hostfwt` parameter of QEMU:

   ```bash
   qemu-system-x86_64 -nic user,model=virtio-net-pci,hostfwd=tcp::10022-:22 ...
   ```

   later we can connect to guest machine using ssh client:

   ```bash
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 10022 root@127.0.0.1
   ```

### Useful QEMU tricks

#### switch VTERM on guest OS

in order to switch to other virtual TTY in guest os, we need to switch to
_monitoring console_ of QEMU using `ctrl+alt+2` and send our key combination
using `sendkey` command:

```bash
sendkey ctrl-alt-f2
```

later we can switch back to default console using `ctrl+alt+1` command.

## Docker

notes about generating docker images using Guix.
