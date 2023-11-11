---
namespace: guix
title: Unattended Upgrades
categories:
  - type:
      - "Development Documents"
  - location:
      - "Development"
      - "Document"
      - "Log"
language: "en"
---

## Setup

Here's how you setup unattended upgrades on PantherX OS:

1. Open `/etc/config.scm` (`nano /etc/config.scm`)
2. Add the `unattended-upgrade-service-type` to the file's services section:

```scheme
(service unattended-upgrade-service-type
          (unattended-upgrade-configuration
           (schedule "0 12 * * *")
            (channels #~(cons*
                         (channel
                          (name 'pantherx)
                          (branch "master")
                          (url "https://channels.pantherx.org/git/panther.git")
                          (introduction
                           (make-channel-introduction
                            "54b4056ac571611892c743b65f4c47dc298c49da"
                            (openpgp-fingerprint
                             "A36A D41E ECC7 A871 1003  5D24 524F EB1A 9D33 C9CB"))))
                          %default-channels))))
```

Update the schedule to whatever you need.

- `"*/30 * * * *"`: Every 30 minutes
- `"0 0 * * *"`: Every day at midnight
- `"0 12 * * *"`: Every day at noon
- `"0 0 * * 0"`: Every Sunday at midnight
- `"0 0 1 * *"`: First day of every month at midnight

Reconfigure with

```bash
sudo guix system reconfigure /etc/config.scm
```

Check the logs:

```bash
tail /var/log/unattended-upgrade.log
```

The log will be created after the first run.

## Misc

- [Unattended Upgrades](https://guix.gnu.org/manual/en/html_node/Unattended-Upgrades.html)
