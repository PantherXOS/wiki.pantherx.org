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

## Usage

### Tips for C/C++ programming

Because Flatpak packages run in a sand-boxed mode, they don't have access to system paths like `/var`. since profiles are located in `/var/guix/profiles` path, they are not accessible for flapak packages by default and if you need to allow an application to have access to them, you need to provide access explicitly using `--filesystem` switch:

```bash
$ flatpak run --filesystem=/var/guix/profiles com.visualstudio.code
```

* Install `C/C++` Extension (`C/C++ for Visual Studio Code`).
* Edit `c_cpp_properties.json`:
  - Press `ctrl-shift-p`
  - Type `C/C++`, find the `C/C++: Edit Configuration (JSON)`
  - Add `{$HOME}/.guix-profile/include/**` to `includePath`.

```json
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "${workspaceFolder}/**",
                "${HOME}/.guix-profile/include/**"
            ],
            "defines": [],
            "compilerPath": "/home/panther/.guix-profile/bin/g++",
            "cStandard": "c11",
            "cppStandard": "c++14",
            "intelliSenseMode": "gcc-x64"
        }
    ],
    "version": 4
}
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

**Reference**: Solution Inspired from a decission on [Guix IRC channel](http://logs.guix.gnu.org/guix/2019-09-10.log#112721).

### Pylint is not installed

Open the OSS Code Terminal and type:

```bash
$ which pylint
/home/franz/.guix-profile/bin/pylint
```

Now go to OSS Code settings and look for:

```
"python.linting.pylintPath": "pylint"
```

and change that to the path you discovered earlier:

```json
"python.linting.pylintPath": "/home/franz/.guix-profile/bin/pylint"
```

### autopep8 is not installed

Similiar to pylint but it may not be installed yet:

```bash
$ guix package -i python-autopep8
$ which autopep8
/home/franz/.guix-profile/bin/autopep8
```

and update related settings:

```json
"python.formatting.autopep8Path": "/home/franz/.guix-profile/bin/autopep8"
```

_Reported not working_
