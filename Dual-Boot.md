---
---

**This is not supported. Proceed at your own risk.**

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