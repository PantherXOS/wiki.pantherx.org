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

## Troubleshooting

### "invalid privatekey" connecting through SSH tunnel

Working with DBeaver you might find that you existing OpenSSH private key does not work with the application; [ref](https://github.com/dbeaver/dbeaver/issues/5845). Here's how-to rectify that:

1. Open DBeaver
2. Help > Install New Software
3. Work with "All available sites"
4. Filter by SSHJ; install the options
5. Restart

Now simply select SSHJ in the connection window, and use your OpenSSH private key as usual.