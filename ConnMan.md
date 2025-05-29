---
namespace: connmann
description: "ConnMan is an internet connection manager for embedded devices running the Linux operating system. The Connection Manager is designed to be slim and to use as few resources as possible, so it can be easily integrated. It is a fully modular system that can be extended, through plug-ins, to support all kinds of wired or wireless technologies. Also, configuration methods, like DHCP and domain name resolving, are implemented using plug-ins. The plug-in approach allows for easy adaption and modification for various use cases."
description-source: "https://en.wikipedia.org/wiki/ConnMan"
categories:
 - type:
   - "Service"
 - location:
   - "Networking"
   - "Network configuration"
   - "Network managers"
language: en
---

## Installation

To install _ConnMan_ run:

```bash
$ guix package -i connman
```

### Front-ends

## Usage

To find out more about _connman_ command line access, review:

```bash
$ connmanctl --help
```

### Ethernet

#### System Configuration

```scheme
(service connman-service-type
         (connman-configuration
           (disable-vpn? #t)))
```

Read more about [System configuration](System-configuration) with GNU Guix.

#### Config file

```
[service_home_ethernet]
Type = ethernet
IPv4 = 192.168.1.42/255.255.255.0/192.168.1.1
IPv6 = 2001:db8::42/64/2001:db8::1
MAC = 01:02:03:04:05:06
Nameservers = 10.2.3.4,192.168.1.99
SearchDomains = my.home,isp.net
Timeservers = 10.172.2.1,ntp.my.isp.net
Domain = my.home
```

### Wi-Fi

```
[service_home_wifi]
Type = wifi
Name = my_home_wifi
Passphrase = password
IPv4 = 192.168.2.2/255.255.255.0/192.168.2.1
MAC = 06:05:04:03:02:01
```

## See also

- [ConnMan service provisioning file](https://manpages.debian.org/testing/connman/connman-service.config.5.en.html)
- [ConnMan on Arch Wiki](https://wiki.archlinux.org/index.php/ConnMan#Wi-Fi)
- [Networking Services on GuixSD](https://www.gnu.org/software/guix/manual/en/html_node/Networking-Services.html)