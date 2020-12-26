---
namespace: android
description: "Android Studio is the official integrated development environment (IDE) for Google's Android operating system, built on JetBrains' IntelliJ IDEA software and designed specifically for Android development."
description-source: "https://en.wikipedia.org/wiki/Android_Studio"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
   - "Development environments"
language: en
---

## Native Environments

_All credit for this excellent approach goes to [Julien Lepiller](https://lepiller.eu/en/). I have really just adapted it for this wiki._

Here we'll use `guix environment` to containerize Android Studio in order to work-around the countless of hard-coded paths that aren't available on PantherX. It's up to Google / JetBrains to fix this.

### Prepare

Download Android Studio from [here](https://developer.android.com/studio).

Store all this stuff wherever you want. I'm using `~/git/`. The final structure I'm looking at, will be something like this:

- Android Studio at `~/git/android/android-studio`
- Android preferences at `~/git/android/home`
- Android SDK (for ease) at `~/Android` (this is what the IDE defaults to)

Here we go:

```bash
$ cd ~/git
$ mkdir android
$ tar -xvzf android-studio-ide-201.6953283-linux.tar.gz -C android
~/git/android/android-studio
```

_I have a bad habit of putting all development stuff under `~/git`. You may put it wherever you want (for ex. `~/dev`), just don't complain._

### Configure the environment

Create a manifest for the environment:

```bash
nano ~/git/android/studio-manifest.scm
```

with the following content:

```scheme
(use-package-modules base bash compression gcc gl glib linux nss pulseaudio
                     version-control virtualization xml xorg)

(packages->manifest
  (list bash git which dbus
        (list gcc "lib")

        ;; for running the android virtual devices (AVD):
        e2fsprogs qemu-minimal
        alsa-lib expat libxcomposite libxcursor libxi libxtst
        mesa nss pulseaudio (list util-linux "lib") libx11 zlib))
```

### Fix included Java

Indeed the included Java at `~/git/android/android-studio/jre` gives us problems, so we'll replace that with our own:

```bash
$ guix build icedtea
/gnu/store/mag0najz2fdiqv6qslkc4b2fm0kj2lxr-icedtea-3.7.0-doc
/gnu/store/h6w6w37dskgdikxy3mywkldicqyfd0zj-icedtea-3.7.0-jdk
/gnu/store/amk6smc2ciaj5w3azsr1qz025c10w7kx-icedtea-3.7.0
$ sudo ln -sv /gnu/store/h6w6w37dskgdikxy3mywkldicqyfd0zj-icedtea-3.7.0-jdk /var/guix/gcroots
$ rm -rf ~/git/android/android-studio/jre
$ ln -sv /var/guix/gcroot/h6w6w37dskgdikxy3mywkldicqyfd0zj-icedtea-3.7.0-jdk /home/franz/git/android/android-studio/jre
```

**The store paths `/gnu/store/h6w6w37dsk...` will vary so watch out!**

### Create simlinks

To keep all Android related stuff in one place, we do:

```bash
mkdir -p ~/git/android/home/android
ln -sv ~/git/android/home ~/.android
ln -sv ~/git/android/home/AndroidStudio4.0 ~/.AndroidStudio4.0
```

### Create the environment

_Assuming you're at `~/git/android`_

```bash
export PROFILE=$(guix environment -C -N -m studio-manifest.scm \
  -- bash -c 'echo $GUIX_ENVIRONMENT')
```

and then, build and enter the container with:

```bash
guix environment -C -N --share=$XAUTHORITY --share=/tmp/.X11-unix \
    --share=/dev/shm --expose=/etc/machine-id --expose=$HOME \
    --expose=$PROFILE/lib=/lib --expose=$PROFILE/lib=/lib64 --share=/dev/kvm \
    -m studio-manifest.scm -- env XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY bash
```

### Run

```bash
LD_LIBRARY_PATH=/lib ./android-studio/bin/studio.sh
```

To run Android Virtual Device (AVD) from Studio:

```bash
LD_LIBRARY_PATH=/lib:/lib/nss:$HOME/Android/Sdk/emulator/lib64/qt/lib:$HOME/Android/Sdk/emulator/lib64
    ./android-studio/bin/studio.sh
```

_This is assuming you installed the SDK at `$HOME` (/home/USERNAME). You will have to run Android Studio once, to download the relevant SDK's before running the last command.._

### Re-run

To run this again, at a later point, go back to `~/git/android` and repeat the last two steps:

1. Create the environment
2. Run

## Known Issues

- There's an issue with built-in `adb`.
- I haven't actually tried the device emulator (AVD)

## See also

- [Running android studio on Guix](https://lepiller.eu/en/running-android-studio-on-guix.html)
