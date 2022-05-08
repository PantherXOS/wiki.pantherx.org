---
namespace: Nebula
description: "Nebula is a scalable overlay networking tool with a focus on performance, simplicity and security. It lets you seamlessly connect computers anywhere in the world. Nebula is portable, and runs on Linux, OSX, Windows, iOS, and Android. It can be used to connect a small number of computers, but is also able to connect tens of thousands of computers."
description-source: "https://github.com/slackhq/nebula"
categories:
  - type:
      - "Application"
  - location:
      - "Software"
      - "Command-line"
language: en
---

## Installation

Install `nebula` with:

```bash
$ guix package -i nebula
```

This will give you access to:

- `nebula`
- `nebula-cert`

## Usage

Refer to [Getting started (quickly)](https://github.com/slackhq/nebula#getting-started-quickly) on Github.

## Service

### Single network

```scheme
(service nebula-service-type)
```

The default config is assumed to be at `/etc/nebula/config.yml`

### Multiple networks

```scheme
(service nebula-service-type
         (list (nebula-configuration
                (provision '(nebula-1))
                (config-path "/etc/nebula/network1/config.yml"))
               (nebula-configuration
                (provision '(nebula-2))
                (config-path "/etc/nebula/network2/config.yml"))))
```
