---
namespace: guix
title: Install GNU Guix on Digital Ocean
categories:
 - type:
   - "Guide"
 - location:
   - "Guix"
   - "Server"
   - "Tutorial"
language: "en"
outdated: true
---

In this tutorial we want to provide a step-by-step guide to transform an existing DigitalOcean droplet
to a Guix System instance.

## Prerequisites

In order to Install Guix System on DigitalOcean, we need a fresh droplet with at least 2GB of memory. In
this tutorial we use a `Debian 9.7` droplet instance as our starting point, and we are installing
`Guix 1.0.1` binaries on it. using other distributions, you might need to change some parts by yourself.


## Installation Process

### Login to Droplet
In order to install Guix System, you need to login to your instance with `root` user:

```bash
ssh -i /path/to/ssh_key root@...
```

### Required Packages
We need to install `xz-utils` package in order to extract the archive file:

```bash
apt-get update
apt-get install xz-utils -y
```

### Guix Binaries
you need to downlad Guix binaries from it's official [website](https://ftp.gnu.org/gnu/guix/), extract and
copy them to your instance:

```bash
wget https://ftp.gnu.org/gnu/guix/guix-binary-1.0.1.x86_64-linux.tar.xz
cd /tmp
tar --warning=no-timestamp -xf ~/guix-binary-1.0.1.x86_64-linux.tar.xz
mv var/guix /var/ && mv gnu /
```

### Prepare Guix profile
In order to prepare Guix profile for `root` user we have to create symlinks in their home directory:

```bash
mkdir -p ~root/.config/guix
ln -sf /var/guix/profiles/per-user/root/current-guix ~root/.config/guix/current

export GUIX_PROFILE="`echo ~root`/.config/guix/current" ;
source $GUIX_PROFILE/etc/profile
```

### Guix Users and Group
In order to run `guix-daemon` we need to create `guixbuild` system group, and add `guixbuilder` users to it:

```bash
groupadd --system guixbuild
for i in `seq -w 1 10`;
do
   useradd -g guixbuild -G guixbuild         \
           -d /var/empty -s `which nologin`  \
           -c "Guix build user $i" --system  \
           guixbuilder$i;
done;
```

### Guix daemon
now we need to run `guix-daemon` and make it to run on boot:

```bash
cp ~root/.config/guix/current/lib/systemd/system/guix-daemon.service /etc/systemd/system/
systemctl start guix-daemon && systemctl enable guix-daemon
```

### Guix Access for all users
now we need to sumlink Guix in order that all users have access to it:

```bash
mkdir -p /usr/local/bin
cd /usr/local/bin
ln -s /var/guix/profiles/per-user/root/current-guix/bin/guix

mkdir -p /usr/local/share/info
cd /usr/local/share/info
for i in /var/guix/profiles/per-user/root/current-guix/share/info/* ;
   do ln -s $i; done
```

### Authorize Official Guix Servers
now we need to add official server public keys to Guix:

```bash
guix archive --authorize < ~root/.config/guix/current/share/guix/ci.guix.gnu.org.pub
```

### Guix Packages
now we need to update Guix package repositories and install required packages:

```bash
guix pull
guix package -i glibc-utf8-locales
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
guix package -i openssl
```

### System configuration File
now that we have a working Guix Package Manager, we have to setup system configuration file.

first we need to create `config.scm` in `/etc/` path:

```shell
touch /etc/config.scm
```

now we need to add following configuration to our system configuration file and modify our network
related details, based on our droplet's details:

```scheme
(use-modules (gnu))
(use-service-modules networking ssh)
(use-package-modules screen ssh certs tls)

;; Update your hostname and timezone
(operating-system
  (host-name "guix")
  (timezone "Asia/Tehran")
  (locale "en_US.UTF-8")

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (target "/dev/vda")))
  (file-systems (cons* (file-system
                        (device "/dev/vda1")
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))
  ;; Add your user account
  (users (cons (user-account
                (name "username")
                (group "users")
                (supplementary-groups '("wheel"))
                (home-directory "/home/username"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons* screen openssh nss-certs gnutls %base-packages))

  ;; Set your Droplet, static network configuration
  (services (cons* (static-networking-service "eth0" "XXX.XXX.XXX.XXX"
                    #:netmask "XXX.XXX.XXX.XXX"
                    #:gateway "XXX.XXX.XXX.XXX"
                    #:name-servers '("84.200.69.80" "84.200.70.40"))
                   (service openssh-service-type
                            (openssh-configuration
                            (permit-root-login 'without-password)))
                   %base-services)))
```

**IMPORTANT NOTE:**  Don't forget to replace network related details which is filled by `XXX.XXX.XXX.XXX`
with your droplet's network related configurations.


### Build Guix System
now, we need to build and reconfigure this configuration file using Guix:

```bash
guix system build /etc/config.scm
guix system reconfigure /etc/config.scm
```

since we are installing Guix System on an existing distro, running `guix system reconfigure`, we will
receive following error:

```bash
guix system: error: symlink: File exists: "/etc/ssl"
```

to solve this issue, we need to remove old configurations of distro, and create a new `/etc` folder for
Guix System, with necessary data:

```bash
mv /etc /old-etc
mkdir /etc
cp -r /old-etc/{passwd,group,shadow,gshadow,mtab,guix} /etc/
```

if we run `guix system reconfigure` again, we will receive _Success_ message:

```bash
guix system reconfigure /etc/config.scm
```

### Reboot
after `reboot`, we could see that old _Debian_ droplet is gone, and we have a running _Guix System_
instance.


## References
This document is an updated version of previously provided [Blog Post](https://f-a.nz/dev/guixsd-on-digitalocean/).
we use [Guix Binary Installation](https://guix.info/manual/en/html_node/Binary-Installation.html) and
[Guix Build Environment Setup](https://guix.info/manual/en/html_node/Build-Environment-Setup.html#Build-Environment-Setup)
documents to update this tutorial to version `1.0.1` of _Guix System_.

Some other useful references are:

- [Guix-Devel Mailing List thread](https://lists.gnu.org/archive/html/guix-devel/2017-04/msg00139.html) which was referenced previously in parent blog post.
- [Official Guix Installation Script](https://git.savannah.gnu.org/cgit/guix.git/tree/etc/guix-install.sh)
