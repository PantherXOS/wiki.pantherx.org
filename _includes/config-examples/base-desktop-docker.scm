;; PantherX OS Desktop Configuration r2
;; boot in "legacy" BIOS mode
;; /etc/system.scm
;;
;; with Docker service

(use-modules (gnu)
             (gnu system)
             (px system install)
             (px system))

;; Add the service module 'docker'
(use-service-modules docker)

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
               (targets '("/dev/sda"))))
       
  (file-systems (cons (file-system
                       (device (file-system-label "my-root"))
                       (mount-point "/")
                       (type "ext4"))
                      %base-file-systems))

  (users (cons (user-account
                (name "panther")
                (comment "panther's account")
                (group "users")

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam. Adding it to "docker"
				;; allows docker deamon access
                (supplementary-groups '("wheel"
                                        "audio" "video" "docker"))
                (home-directory "/home/panther"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons*
   %px-desktop-packages))

  ;; Globally-activated services.
  (services (cons* (service docker-service-type)
   %px-desktop-services))
  ))