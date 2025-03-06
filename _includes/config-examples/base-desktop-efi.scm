;; PantherX OS Configuration

(use-modules (gnu)
             (gnu system)
             (px system panther)
             (gnu packages desktop))

(operating-system
 (inherit %panther-os)
 (host-name "px-base")
 (timezone "Europe/Berlin")
 (locale "en_US.utf8")
 
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets '("/boot/efi"))))

 (file-systems
  (append
   (list 
    (file-system
     (device (file-system-label "my-root"))
     (mount-point "/")
     (type "ext4"))
    (file-system
     (device "/dev/sda1")
     (mount-point "/boot/efi")
     (type "vfat")))
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

 ;; Globally-installed packages.
 (packages %panther-base-packages)

 ;; Globally-activated services.
 (services
  (cons*
   (service xfce-desktop-service-type)
   %panther-desktop-services)))
