(use-modules (gnu)
             (gnu system)
             (px system))

(px-desktop-os
 (operating-system
  (host-name "px-base")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  ;; Boot in EFI mode, assuming /dev/sda is the
  ;; target hard disk, and "my-root" is the label of the target
  ;; root file system.
  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (target "/boot/efi")))
       
  (file-systems (append
        (list (file-system
                (device (file-system-label "my-root"))
                (mount-point "/")
                (type "ext4"))
              (file-system
                (device "/dev/sda1")
                (mount-point "/boot/efi")
                (type "vfat")))
              %base-file-systems))

  (users (cons (user-account
                (name "panther")
                (comment "panther's account")
                (group "users")

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam.
                (supplementary-groups '("wheel"
                                        "audio" "video"))
                (home-directory "/home/panther"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons*
   %px-desktop-packages))

  ;; Services
  (services (cons*
   %px-desktop-services))
  ))