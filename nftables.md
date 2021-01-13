---
namespace: nftables
description: "nftables is a subsystem of the Linux kernel providing filtering and classification of network packets/datagrams/frames. It has been available since Linux kernel 3.13 released on 19 January 2014."
description-source: "https://en.wikipedia.org/wiki/Nftables"
categories:
 - type:
   - "Application"
   - "Firewall"
   - "CI"
 - location:
   - "General"
language: en
---

## Setup

**If you are running PantherX Desktop or Server, this is configured out of the box.**

Add this to your `/etc/system.scm`:

```scheme
(service nftables-service-type)
```

## Usage

These are best run as `root`:

```bash
su - root
```

To see if the service is running:

```bash
$ herd status nftables
Status of nftables:
  It is started.
  Running value is #t.
  It is enabled.
  Provides (nftables).
  Requires ().
  Conflicts with ().
  Will be respawned.
```

List active rules:

```bash
$ nft list ruleset
table bridge filter {
        chain INPUT {
                type filter hook input priority filter; policy accept;
        }

        chain FORWARD {
                type filter hook forward priority filter; policy accept;
        }

        chain OUTPUT {
                type filter hook output priority filter; policy accept;
        }
}
table inet filter {
        chain input {
                type filter hook input priority filter; policy drop;
                ct state invalid drop
                ct state { established, related } accept
                iifname "lo" accept
                ip protocol icmp accept
                ip6 nexthdr ipv6-icmp accept
                tcp dport 22 accept
                reject
        }

        chain forward {
                type filter hook forward priority filter; policy drop;
        }

        chain output {
                type filter hook output priority filter; policy accept;
        }
}
```
