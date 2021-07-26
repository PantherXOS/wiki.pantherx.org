(use-modules (gnu)
             (gnu system)
             (px system))

(use-service-modules docker)
(use-package-modules emacs tmux)

(px-desktop-os
 (operating-system
  (host-name "px-base")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  ;; Boot in "legacy" BIOS mode, assuming /dev/sda is the
  ;; target hard disk, and "my-root" is the label of the target
  ;; root file system.
  (bootloader (bootloader-configuration
               (bootloader grub-bootloader)
               (target "/dev/sda")))
       
  (file-systems (cons (file-system
                       (device (file-system-label "my-root"))
                       (mount-point "/")
                       (type "ext4"))
                      %base-file-systems))

  (users (cons (user-account
                (name "your-name")
                (comment "your-name's account")
                (group "users")

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam.
                (supplementary-groups '("wheel"
                                        "audio" "video"))
                (home-directory "/home/your-name"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons* emacs tmux
   %px-desktop-packages))

  ;; Services
  (services (cons* (service docker-service-type)
   %px-desktop-services))
  ))