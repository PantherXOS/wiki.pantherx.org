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

Read more about [qemu](/qemu/).

### Run as live machine

Let's say you wanted to run PantherX Desktop in a virtual machine.

Create a system config `px-desktop-config_vm.scm`:

```scheme
(use-modules (gnu)
             (gnu system)
             (px system panther)
             (gnu packages desktop))

(operating-system
  (inherit %panther-os)
  (host-name "px-base")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (target "/dev/vda")
              (terminal-outputs '(console))))

  (file-systems (cons (file-system
                       (mount-point "/")
                       (device "/dev/vda1")
                       (type "ext4"))
                     %base-file-systems))

  (users (cons (user-account
                (name "panther")
                (comment "panther's account")
                (group "users")
                ;; Set the default password to 'pantherx'
                ;; Important: Change with 'passwd panther' after first login
                (password (crypt "pantherx" "$6$abc"))

                (supplementary-groups '("wheel"
                                        "audio" "video"))
                (home-directory "/home/panther"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons*
	     %panther-base-packages))

  ;; Globally-activated services.
  (services (cons*
        (service xfce-desktop-service-type)
		   %panther-desktop-services)))

```

Build a VM from `px-desktop-config_vm.scm`:

```bash
guix system vm guix-desktop-vm_image.scm --substitute-urls='https://bordeaux.guix.gnu.org https://packages.pantherx.org'
```

Once that's done, you should get a bash script:

```bash
building /gnu/store/v6s7975lv0z95ss2k7bjc5y5j9myh4ap-copy-image.drv...
building /gnu/store/z73xm20ipfdbqwid5mvlpfysp83lf8m9-run-vm.sh.drv...
/gnu/store/7d6mi0wpfyxsxy25rd8gcnj1x5szdgcr-run-vm.sh
```

Run like this:

```
/gnu/store/7d6mi0wpfyxsxy25rd8gcnj1x5szdgcr-run-vm.sh -m 2048 -smp 2 -nic user,model=virtio-net-pci -enable-kvm
```

Notes:

- `m` is memory
- `smp` is the processor count
- `enable-kvm` will enable hardware acceleration (you should! enable this)

Important: To actually use the `-enable-kvm` flag, you need to enable it for your user, in the system configuration at `/etc/system.scm`. Learn more: [More performance using KVM](/qemu/#more-performance-using-kvm)

{% include snippets/screenshot.html image='Virtualization/guix-desktop-config_vm.png' %}

Login with password `pantherx`.

### Prepare permanent disk image

alternatively we can generate a disk image in QCOW2 format, containing Guix instance installed on match with our provided configuration file.

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

**(1)** generated disk image will be saved in `store`, and since store is a read-only location, we need to copy that to some other place and assign write permission before we can use generated image.

**(2)** default image generated using `guix system vm-image` usually doesn't have enough space for additional files and packages to store/install. so if we need more space, we should pass our desired size using `--image-size` parameter.

```bash
$ guix system vm-image /path/to/config.scm --image-size=10G
```

**(3)** in order to have ssh access to the virtual machine, we need to forward default ssh port of the guest machine to some other port in host using `hostfwt` parameter of QEMU:

```bash
$ qemu-system-x86_64 -nic user,model=virtio-net-pci,hostfwd=tcp::10022-:22 ...
```

**(4)** later we can connect to guest machine using ssh client:

```bash
$ ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 10022 root@127.0.0.1
```

### Useful QEMU tricks

#### switch VTERM on guest OS

in order to switch to other virtual TTY in guest os, we need to switch to _monitoring console_ of QEMU using `ctrl+alt+2` and send our key combination using `sendkey` command:

```bash
sendkey ctrl-alt-f2
```

later we can switch back to default console using `ctrl+alt+1` command.

## See also

- [qemu](/qemu/)
- [Invoking guix system](https://guix.gnu.org/manual/en/html_node/Invoking-guix-system.html)
