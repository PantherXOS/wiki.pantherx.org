---
namespace: verdaccio
description: "Verdaccio is a lightweight private npm proxy registry built in Node.js"
description-source: ""
categories:
  - type:
      - "Application"
  - location:
      - "Development"
language: en
---

Verdaccio is a proxy / registry for npm packages, on which you can publish private packages at the cost of the server it runs on. Here's how'to setup Verdaccio on PantherX Server in 10 minutes.

## Server setup

We're starting out with a blank PantherX Server installation:

Loggin as `root` and get a SSL certificate:

```bash
guix package -i certbot
certbot certonly --standalone -d npm.domain.com
```

Next, back on your computer, prepare the server configuration. You can use the following as a template:

- Add your SSH public key here: `ssh-ed25519 AAAAC3DCaC1lZDI1NDS5AASAAIP7........`
- Adjust the target disk `(target "/dev/sda")))` and `(device "/dev/sda1")`
  - On DigitalOcean VM's thats usuall `(target "/dev/vda")))` and `(device "/dev/vda1")`
  - You can refer to `/etc/config.scm` on the target machine to double-check
- Replace all `npm.domain.com` with your domain
- Adjust the target machine IP address: `(host-name "192.168.1.100")`

```scheme
;; PantherX OS Server deployment template
;; for Digital Ocean
;;
;; Services: PostgreSQL, Redis, Nginx
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
	     (px system config))

(use-service-modules databases networking web certbot)

(define %ssh-public-key
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7........")

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
    (host-name "npm")
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
		     %px-server-packages))
    
    ;; Services
    (services (cons*
	       ;; SSL Certificates
	       (service certbot-service-type
			(certbot-configuration
			 (email "user@domain.com")
			 (certificates
			  (list
			   (certificate-configuration
			    (domains '("npm.domain.com"))
			    (deploy-hook %nginx-deploy-hook))))))
	       
	       ;; Web server
	       (service nginx-service-type
			(nginx-configuration
			 (server-blocks
			  (list 
			   (nginx-server-configuration
			    (server-name '("npm.domain.com"))
			    (listen '("80"))
			    (root "/var/www")
			    (raw-content '("return 301 https://$host$request_uri;")))
			   (nginx-server-configuration
			    (server-name '("npm.domain.com"))
			    (listen '("443 ssl"))
			    (ssl-certificate (cert-path "npm.domain.com" 'fullchain))
			    (ssl-certificate-key (cert-path "npm.domain.com" 'privkey))
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
				 "proxy_pass http://localhost:4873;"
				 "proxy_http_version 1.1;"
				 "proxy_set_header Upgrade $http_upgrade;"
				 "proxy_set_header Connection 'upgrade';"
				 "proxy_set_header Host $host;"
				 "proxy_set_header X-NginX-Proxy true;"
				 "proxy_cache_bypass $http_upgrade;")))
			      )))))))
	       %custom-server-services)))
   
   #:open-ports '(("tcp" "ssh" "80" "443"))
   #:authorized-keys `(("root" ,(plain-file "user.pub" %ssh-public-key))
		       ("panther" ,(plain-file "user.pub" %ssh-public-key)))
   ))

(list (machine
       (operating-system %system)
       (environment managed-host-environment-type)
       (configuration (machine-ssh-configuration
		       (host-name "192.168.1.100")
		       (system "x86_64-linux")
		       (user "root")
		       (identity "id_rsa")
		       (port 22)
		       (allow-downgrades? #t)))))
```

To deploy this configuration, save and deploy:

```bash
guix deploy npm.domain.com.scm
```

## Verdaccio setup

Loggin as `panther` on the target computer (or whatever you set as 2nd user) and install Verdaccio:

```bash
mkdir verdaccio
cd verdaccio/
npm install verdaccio
npm install forever
```

Try running it with:

```bash
$ node_modules/.bin/verdaccio 
 info --- Creating default config file in /home/panther/.config/verdaccio/config.yaml
 warn --- config file  - /home/panther/.config/verdaccio/config.yaml
 warn --- "crypt" algorithm is deprecated consider switch to "bcrypt". Read more: https://github.com/verdaccio/monorepo/pull/580                                                                                                            
 info --- plugin successfully loaded: verdaccio-htpasswd
 info --- plugin successfully loaded: verdaccio-audit
 warn --- http address - http://localhost:4873/ - verdaccio/5.15.4
```

If you have already setup the webserver, you can now open https://npm.domain.com and should see verdaccio.

If you get some errors, try restarting nginx:

- Loggin as `root`
- Run `herd restart nginx`

Once you confirm that the default works, it's time to continue. You may stop Verdaccio for now.

### Authentication

By default you will find the following in the config file (`/home/panther/.config/verdaccio/config.yaml`). Make sure to uncomment **max_users** and **algorithm**:

```yaml
auth:
  htpasswd:
    file: ./htpasswd
    # Maximum amount of users allowed to register, defaults to "+inf".
    # You can set this to -1 to disable registration.
    max_users: -1 # In case you decide to prevent users from signing up themselves, you can set max_users: -1.
    # Hash algorithm, possible options are: "bcrypt", "md5", "sha1", "crypt".
    algorithm: bcrypt # by default is crypt, but is recommended use bcrypt for new installations
    # Rounds number for "bcrypt", will be ignored for other algorithms.
    # rounds: 10
```

For users to authenticate, you would add them to a new `/home/panther/.config/verdaccio/htpasswd` file that looks like this:

```bash
username1:$2b$10$6FxI9NgKBQv6t/gy5gF8IuaxN5BG9AcUDzyzW8VAGOgLfoYMqa3p
username2:$2b$10$ePqZz2NlqJFuu7VmCgsI.OvUhF0tVZFqPPGweeCZJBMJ/0yRljNe
```

Here's how you can generate bcrypt password strings:

```bash
$ guix package -i python-bcrypt
$ python3 -c 'import bcrypt; print(bcrypt.hashpw(b"password", bcrypt.gensalt(rounds=10)))'
b'$2b$10$6FxI9NgKBQv6t/gy5gF8IuaxN5BG9AcUDzyzW8VAGOgLfoYMqa3p.'
```

_Make sure to replace `password` with your desired secret._

### Access

Our goal is to run a private repository, so we modify the **packages** section of the config (`/home/panther/.config/verdaccio/config.yaml`) to look like this:

```yaml
packages:
  '@*/*':
    # scoped packages
    access: $authenticated
    publish: $authenticated
    unpublish: $authenticated
    proxy: npmjs

  '**':
    # allow all users (including non-authenticated users) to read and
    # publish all packages
    #
    # you can specify usernames/groupnames (depending on your auth plugin)
    # and three keywords: "$all", "$anonymous", "$authenticated"
    access: $authenticated

    # allow all known users to publish/publish packages
    # (anyone can register by default, remember?)
    publish: $authenticated
    unpublish: $authenticated

    # if package is not available locally, proxy requests to 'npmjs' registry
    proxy: npmjs
```

### Run

```bash
node_modules/.bin/forever start node_modules/.bin/verdaccio
```

To check that the process is running:

```bash
$ node_modules/.bin/forever list
(node:1045) Warning: Accessing non-existent property 'padLevels' of module exports inside circular dependency
(Use `node --trace-warnings ...` to show where the warning was created)
(node:1045) Warning: Accessing non-existent property 'padLevels' of module exports inside circular dependency
info:    Forever processes running
data:        uid  command                                                           script                      forever pid  id logfile                         uptime                    
data:    [0] UED0 /gnu/store/y3dzvg3y7d2g7gz72pm7fcpyiwphzj2n-node-14.19.3/bin/node node_modules/.bin/verdaccio 890     1012    /home/panther/.forever/UED0.log 0:0:56:15.570999999999913
```

## Configure Clients

Configure your clients to use your new registry:
https://verdaccio.org/docs/installation/#basic-usage
 
To login:

```bash
npm adduser --registry https://npm.domain.com/
Username: username1
Password: 
Email: (this IS public) username1@domain.com
Logged in as username1 on https://npm.domain.com/.
```

To set as default:

```bash
npm set registry https://npm.domain.com/
```