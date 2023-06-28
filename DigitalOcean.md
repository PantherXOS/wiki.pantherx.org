---
namespace: digitalocean
description: "DigitalOcean Holdings, Inc. is an American multinational technology company and cloud service provider."
description-source: "https://en.wikipedia.org/wiki/DigitalOcean"
categories:
  - type:
      - "Hosting"
  - location:
      - "Development"
language: en
---

## Setup

We have uploaded a ready to use image, that you can simply import and start using.

1. Login to DigitalOcean
2. Look for "Images" in the sidebar and select "Custom Images"
3. Import via Url: `https://temp.pantherx.org/px-server-os_do-image_v0.0.1.qcow2`

At this point you should be able to create a new Droplet in the same region and select the image.

Login with:

```
ssh panther@enter_your_droplet_ip_address
# password: pantherx
```

**You should change the password immediately**.

## Generate your own image

```
(use-modules (gnu)
             (px system config))

(px-server-os
 (operating-system
  (host-name "do-image")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  (initrd-modules (cons* "virtio_scsi"
                         %base-initrd-modules))

  (bootloader (bootloader-configuration
               (bootloader grub-bootloader)
               (targets (list "/dev/vda"))))

  (file-systems (cons (file-system
                       (device "/dev/vda1")
                       (mount-point "/")
                       (type "ext4"))
                      %base-file-systems))

  (swap-devices (list (swap-space (target "/swapfile"))))

  (users (cons* (user-account
                 (name "panther")
                 (comment "default user")
                 (password (crypt "pantherx" "$6$abc"))
                 (group "users")
                 (supplementary-groups '("wheel"))
                 (home-directory "/home/panther"))
                %base-user-accounts)))
 #:open-ports '(("tcp" "ssh" "80" "443")))
```

Build with:

```
guix system image --save-provenance --image-size=5G --image-type=qcow2 do-generic-image.scm
```

## Next Steps

You can use above configuration to create a `/etc/system.scm`