---
namespace: hetzner
description: "Hetzner Online GmbH is a company and data center operator based in Gunzenhausen, Germany."
description-source: "https://en.wikipedia.org/wiki/Hetzner"
categories:
  - type:
      - "Hosting"
  - location:
      - "Development"
language: en
---

Refer to [px-install](https://github.com/PantherXOS/px-install) for scripts:
- pantherx-on-digitalocean.sh
- pantherx-on-hetzner-cloud.sh

## Example Configuration

A PantherX server configuration for a typical Node.js application on a Hetzner cloud server:

- NGINX (Certificates via Certbot)
- Redis server
- Open ports: 20, 80, 443
- Authorized key for root and user

A config like this can be deployed with `guix deploy server-config.scm` in as little as 5 minutes.

```scheme
;; PantherX OS Server deployment template
;; for Digital Ocean
;;
;; Services: Redis, Nginx
;; Firewall: 22, 80, 443

;; Init via script in repo: px-install/pantherx-on-digitalocean.sh

(use-modules (gnu)
	     (gnu system)
	     (srfi srfi-1)
	     (px system)
	     (gnu packages tls)
	     (gnu packages base)
	     (gnu packages node)
	     (gnu packages python)
	     (gnu packages databases)
	     (gnu packages networking)
	     (gnu packages commencement)
	     (gnu packages version-control)
	     (px system config)
	     (px packages databases)
	     (px packages device)
	     (px services device))

(use-service-modules databases networking web certbot)

(define %ssh-public-key
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7gcLZzs2JiEx2kWCc8lTHOC0Gqpgcudv0QVJ4QydPg franz")

(define (cert-path host file)
  (format #f "/etc/letsencrypt/live/~a/~a.pem" host (symbol->string file)))

(define %nginx-deploy-hook
  (program-file
   "nginx-deploy-hook"
   #~(let ((pid (call-with-input-file "/var/run/nginx/pid" read)))
       (kill pid SIGHUP))))

(define %custom-server-services
  (modify-services %px-server-services
		   (guix-service-type config =>
                                      (guix-configuration
                                       (inherit config)
                                       (authorized-keys
					(append (list (local-file "/etc/guix/signing-key.pub"))
						%default-authorized-guix-keys))))))

(define %system
  (px-server-os
   (operating-system
    (host-name "domain")
    (timezone "Europe/Berlin")
    (locale "en_US.utf8")
    
    (bootloader (bootloader-configuration
		 (bootloader grub-bootloader)
		 (target "/dev/sda")))
    
    (initrd-modules (append (list "virtio_scsi")
			    %base-initrd-modules))
    
    (file-systems (append
		   (list (file-system
			  (mount-point "/")
			  (device "/dev/sda1")
			  (type "ext4")))
		   %base-file-systems))

    (swap-devices '("/swapfile"))

    ;; Users
    (users (cons (user-account
		  (name "panther")
		  (comment "panther's account")
		  (group "users")
		  
		  (supplementary-groups '("wheel"))
		  (home-directory "/home/panther"))
		 %base-user-accounts))
    
    ;; Packages
    (packages (cons* node-lts git
		     python gcc-toolchain
		     %px-server-packages))
    
    ;; Services
    (services (cons*
	       ;; Database
	       (service redis-service-type)
	       
	       ;; SSL Certificates
	       (service certbot-service-type
			(certbot-configuration
			 (email "email@domain.com")
			 (certificates
			  (list
			   (certificate-configuration
			    (domains '("domain.com"))
			    (deploy-hook %nginx-deploy-hook))))))
	       
	       ;; Web server
	       (service nginx-service-type
			(nginx-configuration
			 (server-blocks
			  (list 
			   (nginx-server-configuration
			    (server-name '("domain.com"))
			    (listen '("80"))
			    (root "/var/www")
			    (raw-content '("return 301 https://$host$request_uri;")))
			   (nginx-server-configuration
			    (server-name '("domain.com"))
			    (listen '("443 ssl"))
			    (ssl-certificate (cert-path "domain.com" 'fullchain))
			    (ssl-certificate-key (cert-path "domain.com" 'privkey))
			    (locations
			     (list
			      (nginx-location-configuration
			       (uri "/")
			       (body
				(list
				 "proxy_set_header X-Real-IP $remote_addr;"
				 "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
				 "proxy_set_header X-Forwarded-Proto $scheme;"
				 "proxy_redirect off;"
				 "proxy_pass http://localhost:3000;"
				 "proxy_http_version 1.1;"
				 "proxy_set_header Upgrade $http_upgrade;"
				 "proxy_set_header Connection 'upgrade';"
				 "proxy_set_header Host $host;"
				 "proxy_cache_bypass $http_upgrade;"))))))))))
	       %custom-server-services)))
   
   #:open-ports '(("tcp" "ssh" "80" "443"))
   #:authorized-keys `(("root" ,(plain-file "panther.pub" %ssh-public-key))
		       ("panther" ,(plain-file "panther.pub" %ssh-public-key)))
   ))

(list (machine
       (operating-system %system)
       (environment managed-host-environment-type)
       (configuration (machine-ssh-configuration
		       (host-name "000.000.000.000")
		       (system "x86_64-linux")
		       (user "root")
		       (identity "id_rsa")
		       (port 22)
		       (allow-downgrades? #t)))))
```