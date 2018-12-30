---
namespace: diff
description:
categories:
 - type:
   - "Guide"
 - location:
   - "General"
language: en
---

## Navigation

### Using Terminal

To see all files in the current folder:

```bash
$ ls
```

To see all files, _including hidden ones_, in the current folder:

```bash
$ ls -a
```

To navigate to a folder, in the current folder:

```bash
$ cd folder-name
```

To navigate to a folder, under a different path:

```bash
$ cd ~/Desktop
```

Notice the `~` before the `/Desktop`. If you add `~` before any path, you're always referencing your _home_ folder.

To see all files in your _home_ folder:

```bash
$ ls ~
```

You'll probably see something like this:

```bash
Desktop/  Documents/  Downloads/  Music/  Pictures/  Public/  Templates/  Videos/
```

To see all files in your _Desktop_ folder:

```bash
ls ~/Desktop
```

Finally, to navigate to your _Desktop_ folder, you can always, from anywhere, do:

```bash
cd ~/Desktop
```

## Paths

### General

```bash
$ ls -a ~
```

#### Bash

[Bash](/Bash) is a command processor that typically runs in your terminal, where you type commands, which cause actions.

- `.bashrc`
- `.bash_profile`
- `.bash_history` a history of all your _bash_ terminal commands

#### Application Specific

- `.gitconfig` contains your _git_ preferences, if you have [git](/git) installed.
- ``

```
$ ls ~/.config
```

### Desktop

#### LXQt

```
$ ls -a ~/.config/lxqt
```

- `debug.log`
- `lxqt.conf`
- `lxqt-powermanagement.conf`  
- `lxqt-runner.conf`
- `notifications.conf`
- `panel.conf`
- `power.conf`
- `session.conf`

```
$ ls -a ~/.config/openbox
```

- `lxqt-rc.xml`
