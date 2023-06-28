---
namespace: i2p
description: "The Invisible Internet Project (I2P) is an anonymous network layer (implemented as a mix network) that allows for censorship-resistant, peer-to-peer communication. "
description-source: "https://en.wikipedia.org/wiki/I2P"
categories:
  - type:
      - "Networking"
  - location:
      - "Development"
language: en
---

## Connect to and browse I2P

Below I will show how-to easily use I2P with a specialized Chrome profile. You can accomplish something similiar with Firefox, but since I use Firefox daily, I decided to make Chrome a dedicated I2P browser.

First of all, install the I2P daemon:

```
guix package -i i2pd
```

Now simply run it. This will create a new config and data directory at `~/.i2pd`:

```
$ i2pd
11:28:27@746/none - i2pd v2.44.0 (0.9.56) starting…
```

Next we'll create a bash script to run Chrome, configured for I2P. Simply save this as `run-i2p-chromium.sh`:

```
#! /usr/bin/env sh
# Launches Chromium, pre-configured for I2P
#
CHROMIUM_I2P="$HOME/i2p/chromium"
mkdir -p "$CHROMIUM_I2P"
/home/franz/.guix-profile/bin/chromium --user-data-dir="$CHROMIUM_I2P" \
--proxy-server="http://127.0.0.1:4444" \
--proxy-bypass-list=127.0.0.1:7657 \
--user-data-dir=$HOME/WebApps/i2padmin \
--safebrowsing-disable-download-protection \
--disable-client-side-phishing-detection \
--disable-3d-apis \
--disable-accelerated-2d-canvas \
--disable-remote-fonts \
--disable-sync-preferences \
--disable-sync \
--disable-speech \
--disable-webgl \
--disable-reading-from-canvas \
--disable-gpu \
--disable-32-apis \
--disable-auto-reload \
--disable-background-networking \
--disable-d3d11 \
--disable-file-system \
--app=http://127.0.0.1:7657 $@
```

This example was copied from here, with minor adaption: https://eyedeekay.github.io/I2P-Configuration-For-Chromium/

Now simply run the script:

```
bash run-i2p-chromium.sh
```

You should be greeted with a Chrome browser window which reads "This site can’t be reached", likely without address bar. 

Simply open a new tab to fix that: (press) F1. 
<br/>Now you can see the service status in the browser: http://127.0.0.1:7070/confignet