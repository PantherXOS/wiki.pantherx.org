---
namespace: lxqt
description: "LXQt is a free and open source Linux desktop environment, that was formed from the merger of the LXDE and Razor-qt projects."
description-source: "https://en.wikipedia.org/wiki/LXQt"
categories:
  - type:
      - "Application"
  - location:
      - "System administration"
      - "Graphical user interfaces"
      - "Desktop environments"
language: en
outdated: true
---

PantherX Desktop comes with LXQt by default.

### Use KWIN instead of Openbox

Install kwin to your profile:

```bash
guix package -i kwin
```

You will have to logout/login or reboot, for LXQt to recognize the change. Then open Settings > LXQt Settings > LXQt Session > Basic Settings, look for "Window Manager" and change from `openbox` to `kwin_x11`. Logout/login or reboot, for the change to take effect.

### Troubleshooting

#### Opening Folders from Directory Menu failed

If you have any issue in opening folders from Directory Menu of LXQt or any other things that will be open by `xdg-open`, maybe this is related to launching `xdg-open` with wrong path.

For making sure you can run `lxqt-panel` in terminal and open a folder from Directory menu, in thic case maybe you will see a warning message like this:

```bash
Launch failed (/gnu/store/j3nj0b5ajd7la5vi11rmhn0fkp6wn9vx-xdg-utils-1.1.3/bin/xdg-open /home/panther)
```

The soltuion is easy, only update your `qtbase` package with `guix package -u qtbase`. This is related to patching the `xdg-utils` path in `qtbase` [here](https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/qt.scm?id=58b85f7f419e77930765647ffc41011c1103066e#n400)

#### Wallpaper resets on reboot

If your wallpaper doesn't survive a reboot, it's likely that some permissions are off.

First of all, check:

```bash
$ ls -la ~/.config/pcmanfm-qt/lx
-r--r--r-- 1 franz users 106 Aug 31  2020 /home/franz/.config/pcmanfm-qt/lxqt/settings.conf
```

Let's add write permission for our user:

```bash
chmod +w ~/.config/pcmanfm-qt/lxqt/settings.conf
```

And double-check:

```bash
$ ls -la ~/.config/pcmanfm-qt/lxqt/settings.conf
-rw-r--r-- 1 franz users 106 Aug 31  2020 /home/franz/.config/pcmanfm-qt/lxqt/settings.conf
```

That's it. All good.
