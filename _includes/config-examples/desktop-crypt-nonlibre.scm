(use-modules (gnu)
             (gnu system)
	     (gnu packages emacs)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (px config))

(use-service-modules docker)

(px-desktop-os
 (operating-system
  (host-name "panther")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")
  
  ;; Audio fixes
  (kernel-arguments
   (cons* "snd_hda_intel.dmic_detect=0"
	  %default-kernel-arguments))
  
  (bootloader (bootloader-configuration
   	       (bootloader grub-efi-bootloader)
   	       (targets '("/boot/efi"))))
  
  ;; Encrypted partition
  (mapped-devices
   (list (mapped-device
	  (source
	   (uuid "329ksade-9238-452b-a5e2-138295b9766d"))
	  (target "cryptroot")
	  (type luks-device-mapping))))
  
  (file-systems (append
		 (list (file-system
			(device "/dev/mapper/cryptroot")
			(mount-point "/")
			(type "ext4")
			(dependencies mapped-devices))
		       (file-system
			(device (uuid "14C5-1711" 'fat32))
			(mount-point "/boot/efi")
			(type "vfat")))
		 %base-file-systems))
  
  (users (cons (user-account
                (name "franz")
                (comment "default")
                (group "users")
                (supplementary-groups '("wheel" "netdev" "docker" "kvm"
                                        "audio" "video"))
                (home-directory "/home/franz"))
               %base-user-accounts))
  
  (packages (cons* emacs
		   %px-desktop-packages))
  
  ;; Services
  (services (cons* (service docker-service-type)
                   (service px-desktop-service-type)
		   %px-desktop-services))))