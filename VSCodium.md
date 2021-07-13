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

## Installation

### Native

```bash
guix package -i vscodium
```

### Flatpak

Optionally, VSCodium is also available as Flatpak (not recommended):

```bash
# install via flatpak
flatpak install flathub com.vscodium.codium
```

## Usage

### Tips for C/C++ programming

#### Visual Studio Code

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
            "compilerPath": "{$HOME}/.guix-profile/bin/g++",
            "cStandard": "c11",
            "cppStandard": "c++14",
            "intelliSenseMode": "gcc-x64"
        }
    ],
    "version": 4
}
```

#### VSCodium

The `C/C++` extension can't be installed in `VSCodium`, you can use `clangd` extension. If the `clangd` was not found in the `PATH` the extension will download the binary file and will run it internally. (If you faced with any issue in running the `clangd` binary file please read the `Foreign binary in Extensions` in `Troubleshooting` part).

#### Improved Sandboxing for Flatpak

Because Flatpak packages run in a sand-boxed mode, they don't have access to system paths like `/var`. since profiles are located in `/var/guix/profiles` path, they are not accessible for flapak packages by default and if you need to allow an application to have access to them, you need to provide access explicitly using `--filesystem` switch:

```bash
$ flatpak run --filesystem=/var/guix/profiles com.visualstudio.code
```

## Troubleshooting

### Debug

If VSCodium refuses to run, try loading it in debug mode. That usually gives at least some insight into what's wrong:

```bash
code --verbose --log debug --disable-gpu
```

### Foreign binary in Extensions

if you faced with any issue in running the binary files in the extension you can run one of the following options as solution. I see this issue for `wakatime`, `cpptool` and `clangd` extension binary files.

First of all run the `ldd` command on the binary file:

```bash
$ ldd path/to/binary/file
 ...
 /lib64/ld-linux-x86-64.so.2
```

The problem related to `ld-linux-x86-64.so.2` library that is not in the `/lib64`, so:

1. You can create a symlink in this path, the `ld-linux-x86-64.so.2` is one of the shared library of `glibc`. Install `glibc` and then create a symlink:

```bash
sudo mkdir /lib64
sudo ln -s /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/ld-linux-x86-64.so.2 /lib64/
```

2. You can patch the binary file and fix the library path:

```bash
patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath  "$(which sh)")")" path/to/binary/file
```

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