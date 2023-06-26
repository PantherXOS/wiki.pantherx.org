---
---

## Stable repositories

On PantherX repositories are defined in a channels file.

1. `guix` contains the majority of packages
2. `nongnu` contains the Non-Free Linux kernel and other packages
3. `pantherx` contains the system configuration and PantherX specific packages

### Default Behaviour

Depending on the user and application you're running, the default channels file varies. The channels file is only important for updates, thus in normal operation (install, remove), you don't need to care.

#### root user

- The `px update apply` command defaults to `/etc/guix/channels.scm` and `/etc/system.scm`
- the `guix pull` command defaults to `~/.config/guix/channels.scm`

We recommend to always run `px update apply` to download and install the latest **system** updates. For system updates, it's important you actually login as `root` using `su - root` before running `px update apply`.

_Hint:_ This only updates global and root profile packages.

#### normal user

- The `px update apply` command defaults to `/etc/guix/channels.scm`
- the `guix pull` command defaults to `~/.config/guix/channels.scm`

We recommend to always run `px update apply` to download and install the latest **user** updates

---

For users unfamiliar with guix, this is probably a lot to swallow. However, there's really only 3 important things to remember:

1. Have a `/etc/guix/channels.scm` in place
2. Run system updates with `su - root` and then `px update apply`
3. Update applications you have installed under your user (not root) with `px update apply`

We also have a handy GUI application "Software" that will do all this for you.

### Channels File

Here's what your `/etc/guix/channels.scm` should look like:

```scheme
;; PantherX Default Channels

(cons* (channel
        (name 'pantherx)
        (branch "master")
        (url "https://channels.pantherx.org/git/panther.git")
         (introduction
          (make-channel-introduction
           "54b4056ac571611892c743b65f4c47dc298c49da"
           (openpgp-fingerprint
            "A36A D41E ECC7 A871 1003  5D24 524F EB1A 9D33 C9CB"))))
       %default-channels)
```