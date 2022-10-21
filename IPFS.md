---
namespace: ipfs
description: "The InterPlanetary File System (IPFS) is a protocol, hypermedia and file sharing peer-to-peer network for storing and sharing data in a distributed file system. IPFS uses content-addressing to uniquely identify each file in a global namespace connecting IPFS hosts."
description-source: "https://en.wikipedia.org/wiki/InterPlanetary_File_System"
categories:
  - type:
      - "File system"
  - location:
      - "System"
language: en
---

## Installation

```bash
guix package -i go-ipfs
```

Initialize a local config:

```bash
$ ipfs init
generating ED25519 keypair...done
peer identity: 12D3KooWDnSN7beiiizfizaAQP7CiCkSakjdsqoqesB5Z6fyUbe
initializing IPFS node at /home/franz/.ipfs
to get started, enter:

        ipfs cat /ipfs/QmQPeNsJPyVWPFDVHbasjdkadlqwdqasX8D2GhfbSXc/readme
```

### Firewall configuration

For IPFS to be able to serve files from your computer, you will need to open TCP port `4001`. Here's what this looks like in the system configuration (`/etc/system.scm`):

```scheme
#:open-ports '(("tcp" "4001"))
```

To apply the changes, run as root:

```bash
# (1) reconfigure
guix system reconfigure /etc/system.scm
# (2) Restart nftables firewall
herd restart nftables
```

You can confirm the port is open, with

```bash
$ nft list ruleset
table inet filter {
        chain input {
                type filter hook input priority filter; policy drop;
                ct state invalid drop
                ct state { established, related } accept
                iifname "lo" accept
                ip protocol icmp accept
                ip6 nexthdr ipv6-icmp accept
                tcp dport 4001 accept # <-----------
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

Lastly setup TCP 4001 port forwarding on your router. Refer to [NAT configuration (docs.ipfs.tech)](https://docs.ipfs.tech/how-to/nat-configuration) for more information.

## Run

Start ipfs:

```bash
$ ipfs daemon
Initializing daemon...
go-ipfs version: 0.11.0
Repo version: 11
System version: amd64/linux
Golang version: go1.17.11
...
API server listening on /ip4/127.0.0.1/tcp/5001
WebUI: http://127.0.0.1:5001/webui
Gateway (readonly) server listening on /ip4/127.0.0.1/tcp/8080
Daemon is ready
```

If you open [http://127.0.0.1:5001/webui](http://127.0.0.1:5001/webui) in your browser, you should see the web interface.

{% include snippets/screenshot.html image='ipfs/webui.png' alt="IPFS Web" %}

## Usage

It's easy enough to add a new file to IPFS via browser, but much faster with command line:

```bash
$ ipfs add Downloads/webui.png
added QmXRnLoUPWev9wNPcGEaHH7tUGhsrj9ntF44MxwYQiUfx3 webui.png
 234.72 KiB / 234.72 KiB [========================================================================================================================] 100.00%
```

This is me, uploading the above screenshot to IPFS.

Now I should be able to download the file from any other computer in the world, assuming it's available (some IPFS node has a copy of the file and is able to serve it - most likely that's just mine, for the moment). Here's what this looks like:

```bash
$ ipfs get QmXRnLoUPWev9wNPcGEaHH7tUGhsrj9ntF44MxwYQiUfx3
Saving file(s) to QmXRnLoUPWev9wNPcGEaHH7tUGhsrj9ntF44MxwYQiUfx3
 234.72 KiB / 234.72 KiB [========================================================================================================================] 100.00%
```

The filename `QmXRnLoUPWev9wNPcGEaHH7tUGhsrj9ntF44MxwYQiUfx3` is pretty meaningless at the moment, but most files should be recognized just fine, even without extention. To make it handling easier, we'll rename it:

```bash
mv QmXRnLoUPWev9wNPcGEaHH7tUGhsrj9ntF44MxwYQiUfx3 webui.png
```

That's it for now.
