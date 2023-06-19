(use-modules (gnu)
             (gnu bootloader)
             (px bootloader u-boot)
             (px packages linux)
             (px services desktop)
             (px system config)
             (px system raspberry)
             (px hardware raspberrypi))

(px-server-os
 (operating-system
  (host-name "test-core")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
               (bootloader u-boot-rpi-arm64-bootloader)
               (targets '("/dev/vda"))
               (device-tree-support? #f)))

  (kernel linux-raspberry-5.15)
  (kernel-arguments (cons "cgroup_enable=memory"
                          %default-kernel-arguments))
  (kernel-loadable-modules %reterminal-kernel-modules)
  (initrd-modules '())

  (file-systems (cons* (file-system
                        (device (file-system-label "BOOT"))
                        (mount-point "/boot/firmware")
                        (type "vfat"))
                       (file-system
                        (device (file-system-label "RASPIROOT"))
                        (mount-point "/")
                        (type "ext4"))
                       %base-file-systems))

  (users (cons (user-account
                (name "panther")
                (group "users") 
                (password (crypt "pantherx" "$6$abc"))
                (supplementary-groups '("wheel" "audio" "video"))
                (home-directory "/home/panther"))
               %base-user-accounts))

  (services (cons* (service disk-init-service-type
                            (disk-init-configuration
                             (device "/dev/mmcblk0")
                             (index "2")
                             (target "/dev/mmcblk0p2")
                             (swap-size "4G")))
                   %px-server-services)))

 #:kernel 'custom
 #:open-ports '(("tcp" "22"))
 #:authorized-keys `(("root" ,(plain-file "test.pub"
                                                         "ssh-ed25519 AAAAC3NzaC1...............ydPg panther")))
 #:templates (list %raspberry-pi-4-template
                   %seeed-reterminal-template))
