---
namespace: vscodium
description: Free/Libre Open Source Software Binaries of VSCode
description-source: "https://github.com/VSCodium/vscodium"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
language: en
---

VSCodium is available on guix through [Flatpak](/Flatpak/) using following command:

```bash
flatpak install flathub com.vscodium.codium
```

## Troubleshooting

### Visual Studio Code is unable to watch for file changes in this large workspace" (error ENOSPC)

> When you see this notification, it indicates that the VS Code file watcher is 
> running out of handles because the workspace is large and contains many files. 
> Before adjusting platform limits, make sure that potentially large folders, 
> such as Python `.venv`, are added to the `files.watcherExclude` setting 
> (more details below). The current limit can be viewed by running:
> 
> ```bash
> cat /proc/sys/fs/inotify/max_user_watches
> ```
> 
> The limit can be increased to its maximum by editing `/etc/sysctl.conf` (except 
> on Arch Linux, read below) and adding this line to the end of the file:
> 
> ```
> fs.inotify.max_user_watches=524288
> ```
> 
> The new value can then be loaded in by running `sudo sysctl -p`.
> 
> [reference](https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc)


Since official solution provided by Microdoft is not available in Guix,
we can't modify the `/etc/sysctl.conf` manually. the alternative solution for Guix is to use `sysctl-service-type` instead and set custom value for `fs.inotify.max_user_watches`
parameter.

```scheme
(service sysctl-service-type
  (sysctl-configuration
    (settings '(("fs.inotify.max_user_watches" . "524288")))))
```

**reference**: Solution Inspired from a decission on [Guix IRC channel](http://logs.guix.gnu.org/guix/2019-09-10.log#112721).
