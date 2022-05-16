---
---

## Troubleshooting

### Host key verification failed.

Open the _known_hosts_ file, and remove the entry.

```bash
nano ~/.ssh/known_hosts
```

# SSH Reverse Runnel

To access a computer behind firewall, without public ID, SSH forwarding is useful.

Assuming 3 components:
- YC: Your computer
- PI: A computer with a public IP and a user `tunnel`
- RC: The computer you are trying to access; user `panther`

On RC run:

```bash
ssh -R 2222:localhost:22 tunnel@116.203.000.000 # PI IP address
```

On YC run:

```bash
ssh -At tunnel@116.203.000.000 ssh panther@localhost -p 2222
```

You should now be connected.


## SSH ProxyJump

You can also use ProxyJump on YC; run:

```bash
ssh -J tunnel@116.203.000.000 panther@localhost -p 2222 -f -N
```

Or

```bash
ssh -p 2222 -o ProxyJump=root@116.203.000.000 panther@localhost
```

## SSH-Copy-Id

```bash
$ ssh-copy-id -p 2222 -o ProxyJump=tunnel@116.203.000.000 panther@localhost
/run/current-system/profile/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/run/current-system/profile/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
panther@localhost's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh -p '2222' -o 'ProxyJump=root@116.203.000.000' 'panther@localhost'"
and check to make sure that only the key(s) you wanted were added.
```