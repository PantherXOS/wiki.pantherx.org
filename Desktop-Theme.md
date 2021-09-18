---
---

**If you are running PantherX Desktop, this is configured out of the box.**

_Important: This will overwrite any styling changes you made._

This plugin adds support for Desktop Theme configuration to PantherX [Settings Service](https://git.pantherx.org/development/applications/px-settings-service).

You can develop your own theme/style for PantherX OS. Currently the `Theme` plugin is responsible for doing five configurations:
1. Qt Palette/Style(`~/.config/lxqt/lxqt.conf`)
    Set the color scheme/palette.

2. lxqt-panel theme (`~/.config/lxqt/panel.conf`)
    Set the lxqt-panel theme name and icon theme for panel.

3. openbox theme(`/.config/openbox/lxqt-rc.xml`)
    Set the openbox theme name.

4. icon theme(`~/.config/lxqt/lxqt.conf`)
    Set the icon theme name for system.

5. claws-mail icon theme (`~/.claws/clawsrc`)


All of above configurations will do by `Theme` plugin. 


### Steps:

* `Theme` Plugin read/load all installed themes.       
  Installed Theme path: `[XDG_DATA_DIRS]/px/themes/` (ex: `~/.guix-profile/share/px/themes`)     
  So you should install your themes to ``[XDG_DATA_DIRS]/px/themes/``

* `Theme` Plugin read/load the current theme.    
  Current Theme File path: `[XDG_CONFIG_HOME]/px/theme.conf` (`~/.config/px/theme.conf`)
  This is the selected `theme` configuration that will be read by `Theme` plugin and load on the system.
  
* Filling the Settings structure and forward to `px-settings-service`.
* Settings GUI will read the Settings structure and load a list of installed themes for user. Now, user can select, preview and apply the desired theme.


### PantherX Theme Config File

You can find two default themes of PantherX [here](https://git.pantherx.org/development/plugins/px-settings-service-plugin-theme-dark-bright).

The file structure after installation in `XDG_DARA_DIRS` is like this:

```
/home/panther/.guix-profile/share/px/themes/
├── bright          # theme name
│   ├── bright.jpg  # screenshot
│   └── theme.conf
└── dark            # theme name
    ├── dark.jpg    # screenshot
    └── theme.conf
```

The `theme.conf` file structure should be like the following content. The values is optional but the section names and key names are required.

```ini
#theme.conf
[General]
name=dark
title=Dark
description=PantherX Dark Theme
screenshot=dark.jpg
version=0.2

[ColorScheme]
base_color=#0f0f0f
highlight_color=#103e69
highlighted_text_color=#ffffff
link_color=#c7edfd
link_visited_color=#466897
text_color=#e6e6e6
window_color=#1e1e1e
window_text_color=#ffffff

[Themes]
icon-theme=breeze-dark              # (4)
lxqt-panel-theme=px-dark            # (1)
openbox=PX-Arc-Dark                 # (2)
gtk-theme=Breeze-Dark               # (5)
gtk-icon-theme=breeze-dark          # (5)
style=Breeze

[clawsmail]
icon-theme=breeze                   # (3)
```

As said, there are 5 configurations which will do via `Theme` plugin. The values of these configurations are related to the following packages that installed (or even customized and installed). We mentioned the relation of following packages and the configuration with numbers in the above file.

1. `px-lxqt-theme` : lxqt-panel theme [link](https://git.pantherx.org/development/desktop/px-lxqt-themes)

2. `px-arc-dark-theme` : openbox theme [link](https://git.pantherx.org/development/desktop/px-openbox-theme)

3. `claws-breeze-theme` : claws-mail icon theme [link](https://www.claws-mail.org/themes.php)

4. `px-icons`: icon theme [link](https://git.pantherx.org/development/desktop/px-icons)

5. `breeze-gtk` : gtk theme [link](https://github.com/KDE/breeze-gtk)

### PantherX Theme Screenshot File

You should put one screenshot beside the `theme.conf`. The installation path of this screenshot should be put as value of `screenshot` in `[General]` part of `theme.conf`. Please consider this line in package definition: [link](https://git.pantherx.org/development/guix-pantherx/-/blob/working-hamzeh/px/packages/px-themes.scm#L48)

### Example

As mentioned above you can find two default themes os PantherX [here](https://git.pantherx.org/development/plugins/px-settings-service-plugin-theme-dark-bright).