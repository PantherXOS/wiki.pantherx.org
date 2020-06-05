---
namespace: shepherd
description: "PantherX and GNU Guix use the GNU Daemon Shepherd as init system, which is developed in tandem with Guix and is written in Guile as well. It was previously known as 'DMD', which stood for 'Daemon managing Daemons' or 'Daemons-managing Daemon', but changed names to avoid collision with the Digital Mars D compiler."
description-source: "https://en.wikipedia.org/wiki/Guix_System_Distribution#GNU_Shepherd"
categories:
 - type:
   - "Application"
 - location:
   - "System administration"
   - "Boot process"
   - "Init"
language: en
---

## Installation

_Shepherd_ is installed by default.

## Usage

List all currently running services:

```bash
$ herd status
```

List information about an individual, running service:

```
$ herd status service-name
```

To start an individual service:

```bash
$ herd start service-name
```

To stop an individual service:

```bash
$ herd stop service-name
```

## See also

- [Guix Manual: Shepherd Services](https://www.gnu.org/software/guix/manual/en/html_node/Shepherd-Services.html)
- [Add Shepherd service to GuixSD](https://www.mndet.net/2016/05/04/guixsd-system-service.html)