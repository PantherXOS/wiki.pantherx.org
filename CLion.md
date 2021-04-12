---
namespace: clion
description: "A powerful IDE from JetBrains helps you develop in C and C++ on Linux, macOS"
description-source: "https://www.jetbrains.com/clion/"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
   - "Development environments"
language: en
---

Running Clion in GuixSD:

### Prepare

Download `clion` for Linux OS from [here](https://www.jetbrains.com/clion/download/other.html) and do these steps:

```bash
$ tar -xvf JetBrains.CLion.XXXX.Y.tar -C /path/to/folder
$ cd /path/to/folder
$ rm clion/jbr -rf
$ guix build icedtea
/gnu/store/xn93xpr25r21gzh6228aijcak1n3gd08-icedtea-3.7.0-doc
/gnu/store/1y4mxpqdans1q8p6wskhklsl335abgqq-icedtea-3.7.0-jdk
/gnu/store/8cvi052nr1cak2sggjy7bq8z29jp9pjz-icedtea-3.7.0
$ sudo ln -sv /gnu/store/1y4mxpqdans1q8p6wskhklsl335abgqq-icedtea-3.7.0-jdk /var/guix/gcroots
$ ln -sv /var/guix/gcroot/1y4mxpqdans1q8p6wskhklsl335abgqq-icedtea-3.7.0-jdk /path/to/folder/clion/jbr
```


### Run

```bash
$ /path/to/folder/clion/bin/clion.sh
```

Update `CMake` and `GDB` path in `Configuration Toolchains`:
- `/home/panther/.guix-profile/bin/cmake` for `CMake`
- `/home/panther/.guix-profile/bin/gdb` for `gdb`

*I assumed you installed `cmake` and `gdb` already.*

### Auto completion

CLion uses an embedded version of `clangd` as language server for auto completion support, and it crashes due to missing library issues. a quick workaround is to disable `clangd` completion and use build-in auto completion support in CLion. for this we need to go to following path

 `settings` > `languages and frameworks` > `C\C++` > `clangd`

and select `Disable Cland completion` option in `code completion` section.

<!-- the other option is to find a solution to use guix provided version of clangd, located in `extra` output of `clang` package. -->

### Trobleshooting 

**Note**    
If you faced with any java runtime exception the CLion version is not matched with installed JDK (`icedtea`). Currently the latest version of `icedtea` is `3.7` that is released for `OpenJDK 8`.

One of popular errors is:

```bash
Error: A JNI error has occurred, please check your installation and try again
Exception in thread "main" java.lang.UnsupportedClassVersionError: com/intellij/idea/Main has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
```

Let's see how the major version numbers map to Java versions:

```
    45 = Java 1.1
    46 = Java 1.2
    47 = Java 1.3
    48 = Java 1.4
    49 = Java 5
    50 = Java 6
    51 = Java 7
    52 = Java 8
    53 = Java 9
    54 = Java 10
    55 = Java 11
    56 = Java 12
    57 = Java 13
```


### Tested Versions

These version tested with this approach and are working with `icedtea@3.7`:

* `CLion-2019.3.4`
* `CLion-2019.3.6`
* `CLion-2020.1`


**Useful Links**
* https://www.mail-archive.com/help-guix@gnu.org/msg08193.html

