---
namespace: steam
description: "Steam is a video game digital distribution service by Valve. It was launched as a standalone software client in September 2003 as a way for Valve to provide automatic updates for their games, and expanded to include games from third-party publishers."
description-source: "https://en.wikipedia.org/wiki/Steam_(service)"
categories:
 - type:
   - "Application"
   - "Games"
 - location:
   - "General"
language: en
---

_We do not endore this platform but do recognize it's value and place in the community._

## Setup

Simply install with:

```bash
guix package -i steam libsteam
````

Take note of the package notes:

> This package provides a script for launching Steam in a Guix container which will use the directory `$HOME/.local/share/guix-sandbox-home' where all games will be installed.

## Usage

Simply launch. It may take up to a minute for Steam to show. It usually starts with a ~ 250 MB update. After that you will be able to login as usual.

This should work for most, if not all games with Linux support.
