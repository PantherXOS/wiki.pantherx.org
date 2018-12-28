---
---

## Installation

To install _ConnMan_ run:

```bash
$ guix package -i connman
```

### Front-ends

## Usage

### Ethernet

#### System Configuration

```scheme
(service connman-service-type
         (connman-configuration
           (disable-vpn? #t)))
```

Read more about [System configuration](System-configuration) on PantherX.

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

#### Enabling and disabling wifi

#### Connecting to an open access point

#### Connecting to a protected access point

#### Using iwd instead of wpa_supplicant

### Settings

### Technologies

## See also

- [ConnMan service provisioning file](https://manpages.debian.org/testing/connman/connman-service.config.5.en.html)
- [ConnMan on Arch Wiki](https://wiki.archlinux.org/index.php/ConnMan#Wi-Fi)
- [Networking Services on GuixSD](https://www.gnu.org/software/guix/manual/en/html_node/Networking-Services.html)