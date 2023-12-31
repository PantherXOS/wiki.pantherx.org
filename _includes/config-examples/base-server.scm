;; PantherX OS Server Configuration v2
;; boot in "legacy" BIOS mode
;; /etc/system.scm

(use-modules (gnu)
             (gnu system)
             (px system config))

(define %ssh-public-key
  "ssh-ed25519 AAAAC3NzaC1lZSJANJQ5AAAAIP7gcASKK1KAM91dl1OC0GqpgcudsaaJ4QydPg panther")

(px-server-os
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
                ;; Set the default password to 'pantherx'
                ;; Important: Change with 'passwd panther' after first login
                (password (crypt "pantherx" "$6$abc"))

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
   %px-server-packages))

  ;; Globally-activated services.
  (services (cons*
   %px-server-services)))

 #:open-ports '(("tcp" "ssh"))
 #:authorized-keys `(("root" ,(plain-file "panther.pub" %ssh-public-key))))