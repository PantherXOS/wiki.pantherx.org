---
---

## Stable repositories

### core

### extra

### community

## Testing repositories

To edit available repositories, for the current user, open `channels.scm` with:

```bash
$ nano ~/.config/guix/channels.scm
```

### testing

To access the current, testing repositories, replace `channels.scm` content with:

```scheme
(list (channel
       (name 'guix)
       (url "https://gitlab+deploy-token-2:DQhsXMAtmhwsQAykVQRy@git.pantherx.org/development/pantherx.git")
       (branch "px-development-stable-v16"))
      (channel
       (name 'pantherx)
       (url "https://gitlab+deploy-token-1:bBkCXd6Z-K9Y2K1bH84E@git.pantherx.org/development/guix-pantherx.git")
       (branch "master")))
```

### lxqt-unstable

### gnome-unstable

### kde-unstable

## Staging repositories
