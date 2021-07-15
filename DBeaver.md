---
namespace: git
description: "DBeaver is a SQL client software application and a database administration tool. For relational databases it uses the JDBC application programming interface (API) to interact with databases via a JDBC driver."
description-source: "https://en.wikipedia.org/wiki/DBeaver"
categories:
  - type:
      - "Application"
  - location:
      - "Development"
      - "Utilities"
      - "Databases"
language: en
---

## Installation

DBeaver is not yet available on PantherX but you can install it anyway, using Flatpak.

If you don't have Flatpak, simply run:

```bash
guix package -i flatpak
```

Then install DBeaver:

```
$ flatpak search dbeaver
Name                         Description                                       Application ID                                       Version           Branch           Remotes
DBeaver Community            Universal Database Manager.                       io.dbeaver.DBeaverCommunity                          7.2.3             stable           flathub
PostgreSQL Client            PostgreSQL client for DBeaver Community           io.dbeaver.DBeaverCommunity.Client.pgsql                               stable           flathub
MariaDB Client               MariaDB client for DBeaver Community              io.dbeaver.DBeaverCommunity.Client.mariadb                             stable           flathub
$ flatpak --user install io.dbeaver.DBeaverCommunity
```

## Troubleshooting

### "invalid privatekey" connecting through SSH tunnel

Working with DBeaver you might find that you existing OpenSSH private key does not work with the application; [ref](https://github.com/dbeaver/dbeaver/issues/5845). Here's how-to rectify that:

1. Open DBeaver
2. Help > Install New Software
3. Work with "All available sites"
4. Filter by SSHJ; install the options
5. Restart

Now simply select SSHJ in the connection window, and use your OpenSSH private key as usual.
