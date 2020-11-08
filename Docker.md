---
namespace: git
description: "Docker is a set of platform as a service (PaaS) products that use OS-level virtualization to deliver software in packages called containers.[6] Containers are isolated from one another and bundle their own software, libraries and configuration files; they can communicate with each other through well-defined channels."
description-source: "https://en.wikipedia.org/wiki/Docker_(software)"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
   - "Virtualization"
language: en
---

## Installation

Switch to **root** for installation:

```
su - root
```

Open the system configuration:

```bash
nano /etc/system.scm
```

### "Import" the module

Define the required module:

1. Look for `(use-modules (gnu)` right at the top of the file
2. Add `(gnu packages docker)` and `(gnu services docker)` anywhere _directly below_ (1)

The final result may look like this:

```lisp
(use-modules (gnu)
             (gnu packages docker)
             (gnu services docker)
```

### Install Docker for all user

Look for "GLOBAL PACKAGES".

If you do not have any packages defined, add:

```lisp
;; SERVICES
(packages (cons* docker docker-compose
                 %pantherx-packages))
```

If you already have any existing packages defined,
simply merge `docker` and `docker-compose` with the existing
values like so:

```lisp
;; PACKAGES
(packages (cons* i3-vm i3status
		 docker docker-compose               
                 %pantherx-packages))
```

### Enable the service

Scroll to the bottom, and look for "SERVICES".

If you do not have any services defined,  add:

```lisp
;; SERVICES
(services (cons (service docker-service-type)
                         %pantherx-services))
```

If you already have an existing service, add `docker-service-type` like this:

```lisp
;; SERVICES
(services (cons* (service nftables-service-type)
                 (service docker-service-type)
                          %pantherx-services))
```

### Give users access to the service

Look for "USERS" and add the `docker` group to the `supplementary-groups` of the user that you hope to run docker under.

The result may look like this:

```lisp
;; USERS
(users (cons (user-account
               (name "franz")
               (comment "default")
               (group "users")
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video" "docker")))
               %base-user-accounts))
```

### Reconfigure your system

```bash
guix pull # optional
guix system reconfigure /etc/system.scm
```

Reboot with `reboot`.

### Install the application

Now simply install Docker under whichever user you would like to use it.

_Do not run these as root._

```bash
guix package -i docker-cli docker-compose
```

## See also

- [Docker Service (guix.gnu.org)](https://guix.gnu.org/manual/en/html_node/Miscellaneous-Services.html#Docker-Service)
