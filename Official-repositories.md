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

- The `px update apply` command defaults to `/etc/channels.scm` and `/etc/system.scm`
- the `guix pull` command defaults to `~/.config/guix/channels.scm`

We recommend to always run `px update apply` to download and install the latest **system** updates. For system updates, it's important you actually login as `root` using `su - root` before running `px update apply`.

_Hint:_ This only updates global and root profile packages.

#### normal user

- The `px update apply` command defaults to `/etc/channels.scm`
- the `guix pull` command defaults to `~/.config/guix/channels.scm`

We recommend to always run `px update apply` to download and install the latest **user** updates

---

For users unfamiliar with guix, this is probably a lot to swallow. However, there's really only 3 important things to remember:

1. Have a `/etc/channels.scm` in place
2. Run system updates with `su - root` and then `px update apply`
3. Update applications you have installed under your user (not root) with `px update apply`

We also have a handy GUI application "Software" that will do all this for you.

### Channels File

#### Desktop

For our default desktop environment, we default to the standard Linux kernel for maximum hardware compatibility.

Here's what your `/etc/channels.scm` should look like:

```scheme
;; PantherX Default Desktop Channels

(list (channel
        (name 'guix)
        (url "https://channels.pantherx.org/git/pantherx.git")
        (branch "rolling-nonlibre"))
      (channel
        (name 'nongnu)
        (url "https://channels.pantherx.org/git/nongnu.git")
        (branch "rolling"))
      (channel
        (name 'pantherx)
        (url "https://channels.pantherx.org/git/pantherx-extra.git")
        (branch "rolling")))
```

#### Server

For server deployment, you probably be fine with the Linux libre kernel.

Here's what your `/etc/channels.scm` should look like:

```scheme
;; PantherX Default Server Channels

(list (channel
        (name 'guix)
        (url "https://channels.pantherx.org/git/pantherx.git")
        (branch "rolling-nonlibre"))
      (channel
        (name 'pantherx)
        (url "https://channels.pantherx.org/git/pantherx-extra.git")
        (branch "rolling")))
```
