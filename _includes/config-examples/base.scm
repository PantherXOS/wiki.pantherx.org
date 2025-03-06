;; PantherX OS Configuration

(use-modules (gnu)
             (gnu system)
             (px system panther))

(operating-system
 (inherit %panther-os)
 (host-name "px-base")
 (timezone "Europe/Berlin")
 (locale "en_US.utf8")
 
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets '("/dev/sda"))))
 
 (file-systems
  (cons
   (file-system
    (device (file-system-label "my-root"))
    (mount-point "/")
    (type "ext4"))
   %base-file-systems))
 
 (users
  (cons
   (user-account
    (name "panther")
    (comment "panther's account")
    (group "users")
    ;; Set the default password to 'pantherx'
    ;; Important: Change with 'passwd panther' after first login
    (password (crypt "pantherx" "$6$abc"))
    (supplementary-groups '("wheel" "audio" "video"))
    (home-directory "/home/panther"))
   %base-user-accounts))

  (packages %panther-base-packages)
  (services %panther-base-services))
