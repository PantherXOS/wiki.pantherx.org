;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server.
;; read more at https://www.gnu.org/software/guix/manual/en/guix.html#Using-the-Configuration-System

(use-modules (gnu))
(use-service-modules networking ssh)
(use-package-modules screen)

(operating-system
  (host-name "panther")
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

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
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
  (packages (cons screen %base-packages))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (cons* (service dhcp-client-service-type)
                   (service openssh-service-type
                            (openssh-configuration
                              (port-number 2222)))
                   %base-services)))