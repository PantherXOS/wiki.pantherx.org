# PantherX Wiki

## Working with the Wiki

To create a new file, use the title as file name, for example: `LXQt.md`.

For Jekyll to pick up the file, add some font matter:

```
---
---
```

A new entry `ConnMan.md` may start like this:

```
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
```

## Developing this Wiki

To run this Wiki locally, you need to install `bundle`, `yarn` and `jekyll`.

### Set-up Environment

Install

```bash
guix shell node pnpm ruby@2 bundler make gcc-toolchain@12
BUNDLE_PATH=.bundler bundle install
pnpm install
```

Build:

```bash
pnpm exec gulp
BUNDLE_PATH=.bundler bundle exec jekyll build -d .site
```

### Run Site

```bash
BUNDLE_PATH=.bundler bundle exec jekyll serve -d .site
```

## Deployment

Handled by Gitlab CI but may be tested locally:

```bash
bash deploy.sh
```