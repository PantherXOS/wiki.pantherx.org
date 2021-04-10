---
namespace: vscode
description: freeware source-code editor made by Microsoft for Windows, Linux and macOS. 
description-source: "https://code.visualstudio.com/"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
language: en
---

VSCode is available on guix through [Flatpak](/Flatpak/) using following command:

```bash
flatpak install flathub com.visualstudio.code
```

### Running in GuixSD
since Flatpak packages run in a sand-boxed mode, they don't have access to system paths like `/var`. since profiles are located in `/var/guix/profiles` path, they are not accessible for flapak packages by default and if you need to allow an application to have access to them, you need to provide access explicitly using `--filesystem` switch:

```bash
$ flatpak run --filesystem=/var/guix/profiles com.visualstudio.code
```

### Using for C/C++ programming
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