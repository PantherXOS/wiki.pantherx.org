---
namespace: git
description: "Docker is a set of platform as a service (PaaS) products that use OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software, libraries and configuration files; they can communicate with each other through well-defined channels."
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

```bash
$ su - root
```

Open the system configuration:

```bash
$ nano /etc/system.scm
```

### "Import" the module

Define the required module:

1. Look for `(use-modules (gnu)` right at the top of the file
2. Add `(gnu packages docker)` anywhere _directly below_ (1)
3. Add `(use-service-modules docker)` below

The final result may look like this:

```scheme
(use-modules (gnu)
             (gnu system)
			 (gnu packages docker)
             (px system))

(use-service-modules docker pm)
```

### Install Docker for all user

**Skip this is you would like to install docker under a specific user.**

If you do not have any packages defined, add:

```scheme
;; SERVICES
(packages (cons* docker docker-compose
                 %px-desktop-packages))
```

If you already have any existing packages defined,
simply merge `docker` and `docker-compose` with the existing
values like so:

```scheme
;; PACKAGES
(packages (cons* i3-vm i3status
		   docker docker-compose               
                 %px-desktop-packages))
```

### Enable the service

Scroll to the bottom, and look for "SERVICES".

If you do not have any services defined,  add:

```scheme
;; SERVICES
(services (cons* (service docker-service-type)
   				 %px-desktop-services))
```

If you already have an existing service, add `docker-service-type` like this:

```scheme
;; SERVICES
(services (cons* (service nftables-service-type)
                 (service docker-service-type)
                 %px-desktop-services))
```

### Give users access to the service

Look for "USERS" and add the `docker` group to the `supplementary-groups` of the user that you hope to run docker under.

The result may look like this:

```scheme
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

To update and reconfigure your system in one-go:

```bash
$ px update apply
```

If you prefer to simply apply the config change, without updating:

```bash
$ guix system reconfigure /etc/system.scm
```

Reboot with `reboot`.

### Install the application

**If you skipped "Install Docker for all user", run this.**

Now simply install Docker under whichever user you would like to use it.

_Run this under your own user account!._ If you don't know who you are, run: `whoami`.

```bash
$ guix package -i docker-cli docker-compose
```

## Troubleshooting

### No network inside container during docker build

I sometimes encounter a situation where Docker itself seems to be able to communicate fine, but connectivity fails during the build process. To rely on host-network during build, modify your `docker-compose.yml` like so:

```yml
version: "3.7"
services:
  someapp:
     build: 
	context: .
        network: host
```

### Cannot connect to the Docker daemon at unix:///var/run/docker.sock

Docker is either not configured or not running.

#### Not running

```bash
# login as root
su - root

# list services; dockerd is not running
herd status

# start dockerd
herd start dockerd

# go back to your user
exit
```

#### Not configured

Ensure you have the `(service docker-service-type)` configured in your `/etc/system.scm`.

```scheme

...

(use-service-modules docker) ;; define the module

(px-desktop-os
  (operating-system

...

(services (cons* (service docker-service-type) ;; invoke the service
   %px-desktop-services))

...

  ))

```

### Cannot start service: ... mkdir /run/containerd/io.containerd.runtime.v1.l

```bash
ERROR: for some-container  Cannot start service postgres: mkdir /run/containerd/io.containerd.runtime.v1.linux/moby/f0ea188b22896d4ddfb70e6977c496fc8537678c11142ca7cb9514d7b22e4b7d: file exists: unknown
```

or this one:

```bash
ERROR: for redis  Cannot start service redis: mkdir /run/containerd/io.containerd.runtime.v1.linux/moby/8b2fafcf0a961f4fa49a82b3060030b6bc7bb27bd6dc51ccb6b7b71257dbc3bd: file exists: unknown
```

This is an ugly one and I've yet to find the time to look into it properly but `rm -rf` has been working reliably for weeks, without issues or data loss (**!!use at your own risk!!**). So nuke that with: 

```bash
rm -rf /run/containerd/io.containerd.runtime.v1.linux/moby/f0ea188b22896d4ddfb70e6977c496fc8537678c11142ca7cb9514d7b22e4b7d` and try again.
```

	
## See also

- [Docker Service (guix.gnu.org)](https://guix.gnu.org/manual/en/html_node/Miscellaneous-Services.html#Docker-Service)
