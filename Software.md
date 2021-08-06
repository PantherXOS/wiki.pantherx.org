---
---

**If you are running PantherX Desktop, this is configured out of the box.**

Software is the best place to find, install and manage your applications. Software also keeps all your applications up to date, and informs you when operating system updates are available.

The interface is divided in 3 parts:

1. "Store": This is where you can find new applications
2. "Your Apps": This is where you can manage all applications you have installed as user
3. "System" This is where you can update your operating system

### Tips

**Important**: All applications you install under your user, will only be available to your user.

- Every user may install one or more different versions of each application, without conflict
- If you want to install a application globally, use the System Configuration
- Globally installed applications are not listed in Software
- You cannot uninstall globally installed applications without modifying the system configuration
- The `root` user has it's own profile and applications you install there, are only available to the `root` user
- Installing an application to one user, and then to another user, won't download the application again (unless the version is different)

Think of it this way:

1. There's a central `store` of all installed applications (globally, or user-specific)
2. When you install a application, it get's stored in `store`, from where it's made available to the user

```
blender                 2.92.0                  out     /gnu/store/d0ana4r6k86mp60xcvfw08xxywanmnwb-blender-2.92.0
```

So even if you install a application two times (under different users), it will only be downloaded and stored once.

## Other Applications

### Search

Software is far from complete and only a few applications are listed. If you are looking for something specific, you can always hop into the terminal and search manually. For example, here's how-to find Thunderbird:

```bash
$ guix package -s thunderbird
name: icedove
version: 78.12.0
outputs: out
systems: x86_64-linux
dependencies: autoconf@2.13 bzip2@1.0.8 cairo@1.16.0 clang@9.0.1 cups@2.3.3 dbus-glib@0.110 eudev@3.2.9 ffmpeg@4.4 freetype@2.10.4 gdk-pixbuf@2.40.0 glib@2.62.6 gtk+@2.24.32 gtk+@3.24.24 hunspell@1.7.0
+ icu4c@67.1 libcanberra@0.30 libevent@2.1.11 libffi@3.3 libgnome@2.32.1 libjpeg-turbo@2.0.5 libpng-apng@1.6.37 libvpx@1.10.0 libxcomposite@0.4.5 libxft@2.3.3 libxinerama@1.1.4 libxscrnsaver@1.2.3 libxt@1.2.0
+ llvm@9.0.1 mesa@20.2.4 mit-krb5@1.18 nasm@2.14.02 node@10.24.0 nspr@4.29 nss@3.59 pango@1.44.7 perl@5.30.2 pixman@0.38.4 pkg-config@0.29.2 pulseaudio@14.0 python2@2.7.17 python@3.8.2 rust-cbindgen@0.14.1
+ rust@1.41.1 sqlite@3.31.1 startup-notification@0.12 unzip@6.0 which@2.21 yasm@1.3.0 zip@3.0 zlib@1.2.11
location: gnu/packages/gnuzilla.scm:1312:2
homepage: https://www.thunderbird.net
license: MPL 2.0
synopsis: Rebranded Mozilla Thunderbird email client  
description: This package provides an email client built based on Mozilla Thunderbird.  It supports email, news feeds, chat, calendar and contacts.
relevance: 5
```

### Install

Once you found what you're looking for, simply install with:

```bash
guix package -i icedove
```

### List

If you want to see a list of installed applications, you have two options:

1. Open Software and navigate to "Installed" (this includes all applications, no matter how you installed them)
2. Run a command in terminal

```bash
$ guix package --list-installed
aspell                  0.60.8                  out     /gnu/store/zrmhnj3pwchn2msphgnwzwd3q89m46rn-aspell-0.60.8
aspell-dict-uk          1.4.0-0                 out     /gnu/store/4m9cd7wzk36yqggq9qjibc292wa844b5-aspell-dict-uk-1.4.0-0
zip                     3.0                     out     /gnu/store/sm5b6s7zlhwbawxw1vyqxmhggahkb5s0-zip-3.0
binutils                2.34                    out     /gnu/store/0j6mbc117b1yda9jwy9qdg7mps26g4dk-binutils-2.34
stress                  1.0.4                   out     /gnu/store/cm2fg1h2ad6v6zqwiiv1avg1mv2jzn66-stress-1.0.4
make                    4.3                     out     /gnu/store/4k33n2nhsnnaxk2ip75gj7xiqdjns5hq-make-4.3
automake                1.16.2                  out     /gnu/store/1l38jl5mhkb1ypw922njxmnsb6w8zwaw-automake-1.16.2
font-adobe-source-sans-pro      3.028R                  out     /gnu/store/kzgf9zlj3qzyagfspk1m3jilibv3wz61-font-adobe-source-sans-pro-3.028R
unicode-emoji           12.0                    out     /gnu/store/48php8jr9bj223njgyxaaqi5xd4fh9cc-unicode-emoji-12.0
patchelf                0.11                    out     /gnu/store/qz7wcgzdyjxbj08jx89nx3w9k8zs7p7v-patchelf-0.11
unrar                   6.0.2                   out     /gnu/store/3dl6wb5v7lw514ym4hx7x162g91f0d40-unrar-6.0.2
pwgen                   2.08                    out     /gnu/store/r7vvk2rbxfy8qc9x4d9ls0ic1vyqmzid-pwgen-2.08
pkg-config              0.29.2                  out     /gnu/store/krpyb0zi700dcrg9cc8932w4v0qivdg9-pkg-config-0.29.2
musl                    1.2.2                   out     /gnu/store/abq4a937ssb7r3sm1qalcvk7paawr54h-musl-1.2.2
```

### Remove

To remove a application from your profile, run:

```bash
guix package -r icedove
```