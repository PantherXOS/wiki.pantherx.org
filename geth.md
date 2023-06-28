---
namespace: geth
description: "Go-ethereum (aka Geth) is an Ethereum client built in Go. It is one of the original and most popular Ethereum clients."
description-source: ""
categories:
  - type:
      - "Application"
  - location:
      - "Development"
language: en
---

## Setup

```
guix package -i geth
```

## Newer version

Sometimes packages aren't updated as quickly as you need them, or you want to test a unstable version without writing a package. Here's how-to do it.

### Setup

Get the latest download URL from [here (ethereum.org)](https://geth.ethereum.org/downloads/); ex.:

```bash
cd /tmp
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.25-69568c55.tar.gz
```

Extract the file:

```bash
$ tar -zxvf geth-linux-amd64-1.10.25-69568c55.tar.gz 
geth-linux-amd64-1.10.25-69568c55/
geth-linux-amd64-1.10.25-69568c55/COPYING
geth-linux-amd64-1.10.25-69568c55/geth
```

Move into a more permanent location:

```bash
mkdir ~/bin
mv geth-linux-amd64-1.10.25-69568c55/geth ~/bin/
```

Run:

```bash
$ ~/bin/geth

INFO [10-09|18:46:27.516] Starting Geth on Ethereum mainnet... 
INFO [10-09|18:46:27.518] Bumping default cache on mainnet         provided=1024 updated=4096
INFO [10-09|18:46:27.523] Maximum peer count                       ETH=50 LES=0 total=50
INFO [10-09|18:46:27.558] Set global gas cap                       cap=50,000,000
...
```

If you're seeing warnings like these:

```bash
WARN [10-09|19:14:54.538] Post-merge network, but no beacon client seen. Please launch one to follow the chain!
```

here's what seems to be a good guide to setup a beacon client and connect to geth: [docs.prylabs.network](https://docs.prylabs.network/docs/install/install-with-script)