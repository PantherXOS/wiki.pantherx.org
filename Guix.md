---
namespace: guix
description: "GNU Guix is a package manager. It is based on the Nix package manager with Guile Scheme APIs and specializes in providing exclusively free software."
description-source: "https://en.wikipedia.org/wiki/GNU_Guix"
categories:
 - type:
   - "Application"
 - location:
   - "Software"
   - "Command-line"
   - "Package managers"
language: en
---

## Usage

### Installing packages

#### Installing specific packages

To install a single package or list of packages, including dependencies, issue the following command:

```bash
$ guix package -i package-name1 package-name2 ...
```

##### Install specific package version

```scheme
emacs
gcc-toolchain@7
gcc-toolchain:debug
```

### Removing packages

To remove a single package:

```bash
$ guix package -r package-name
```

### Upgrading packages

The following command synchronizes the repository channels and updates the system package references, excluding "local" packages that are not in the configured repositories:

**Get updates**

```bash
$ guix pull
```

To update to a specific _commit_:

```bash
$ guix pull --commit=commit
```

To update to a specific _branch_:

```bash
$ guix pull --branch=branch
```

To update from specific channels, from _file_:

```bash
$ guix pull -C file
```

**Apply updates**

To update a single package:

```bash
$ guix package -u package-name
```

#### Upgrading the system

To perform a system update:

```bash
$ guix system reconfigure /etc/config.scm
```

#### Roll-back a system upgrade

To roll back your system, list the available system generations:

```bash
$ guix system list-generations
```

and initiate a roll-back, to the desired generation:

```bash
$ guix system switch-generation number
```

### Querying package channels

_Guix_ can search for packages in the channel, searching both in packages' names and descriptions:

```bash
$ guix package -s package-name
```

To show more information about an individual package:

```bash
$ guix package --show=package-name
```

#### Add a new package channel

Channels specify Git repositories where `guix pull` looks for updates to Guix and external package repositories. By default guix pull reads `~/.config/guix/channels.scm`; with -C it can take channel specifications from a user-supplied file that looks like this:

```scheme
(cons (channel
       (name ’guix-hpc)
       (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
       (branch "master"))
      %default-channels)
```

### Cleaning the package cache

_Guix_ stores its downloaded packages in `/gnu/store/` and does not remove the old or uninstalled versions automatically. This has some advantages:

- It allows to downgrade a package without the need to retrieve the previous version
- A package that has been uninstalled can easily be reinstalled directly from the cache folder

However, it is necessary to deliberately clean up the cache periodically to prevent the folder to grow indefinitely in size.

To collect remove all old or uninstalled versions:

```bash
$ guix gc
```

To remove _n_ GB of packages:

```bash
$ guix gc -C nG
```

To ensure that _n_ GB of space are available:

```bash
$ guix gc -F nG
```

To remove generations (packages) older than - e.g. _1m_ for one month

```bash
guix package -d duration
```

### Additional commands

#### Developing Packages

To view package definitions:

```bash
$ guix edit package-name
```

To build packages:

```bash
$ guix build package-name1 package-name2
```

To view the build log:

```bash
$ guix build --log-file package-name
```

To build packages and keep result on failure:

```bash
$ guix build -K package-name
```

To obtain the source code:

```bash
$ guix build -S package-name
```

To rebuild the package:

```bash
$ guix build --check package-name
```

To ross-compile to triplet—e.g., _arm-linux-gnueabihf_:

```bash
$ guix build --target=triplet ...
```

To download from _URL_ and print it's SHA256 hash

```bash
$ guix download URL
```

To print the hash of _file_:

```bash
$ guix hash file
```

To view dependencies:

```bash
$ guix graph package-name
```

To count dependent packages:

```bash
$ guix refresh -l package-name
```

To update package definition:

```bash
$ guix refresh package-name
```

To import JSON package metadata from _file_:

```bash
$ guix import json file
```

To import _package_ from _repo_:

```bash
$ guix import repo package
```

To lint packages:

```bash
$ guix lint package-name
```

#### Creating Application Bundles
* The `guix pack` command creates a shrink-wrapped pack or software bundle: it creates a tarball or some other archive containing the binaries of the software you’re interested in, and all __its dependencies__.
* The resulting archive can be used on __any machine__ that __does not have Guix__, and people can run the exact same binaries as those you have with Guix.

To create a tarball:

```bash
$ guix pack spec ...
```

The result here is a tarball containing a `/gnu/store` directory with all the relevant packages.   
__Note 1__ _Users of this pack would have to run /gnu/store/…-profile/bin/guile to run Guile_

To create a Docker image:

```bash
$ guix pack -f docker spec ...
```

To create a Singularity image:

```bash
$ guix pack -f squashfs spec ...
```

To create a relocatable tarball:

```bash
$ guix pack --relocatable spec ...
```

To create a tarball where _/bin_ symlinks to the packages _bin_ directory (To work around __Note 1__):

```bash
$ guix pack -S /bin=bin spec ...
```

That way, users can happily type /opt/gnu/bin/guile and enjoy.


To create a package from manifest in _file_:

```bash
$ guix pack -m file
```

#### Creating Environments

To create an environment containing _spec ..._:

```bash
$ guix environment --ad-hoc spec...
```

To create an environment to develop Python itself:

```bash
$ guix environment python
```

To run Python in a container:

```bash
$ guix environment --ad-hoc python -C -- python3
```

To create an environment for packages in manifest _file_:

```bash
guix environment -m file
```

## Troubleshooting

### guix substitute

#### guix substitute: error: connect: Network is unreachable (mirror down)

This happens, when either your network is down, or the _guix mirror_ is unreachable.

```bash
substitution of /gnu/store/2lc6b2yfa7vkxbfvsf5pjwwp467g9lik-cairo-1.14.10.tar.xz failed
guix substitute: error: connect: Network is unreachable
substitution of /gnu/store/84dgv1gy1cyms37zlmykpsafbpwbm7xr-dbus-1.12.6 failed
guix substitute: error: connect: Network is unreachable
substitution of /gnu/store/hqhzp6d2b396yqdcappqbjk8xz1fm9jl-flex-2.6.1 failed
guix substitute: error: connect: Network is unreachable
```

To use an alternative _guix mirror_, you'll need to authorize it first.

**(1)** Get the _guix mirror_ public key and save it:

```bash
$ nano berlin.guixsd.org.pub
```

The public key for _berlin.guixsd.org_ is:

```scheme
(public-key
 (ecc
  (curve Ed25519)
  (q #8D156F295D24B0D9A86FA5741A840FF2D24F60F7B6C4134814AD55625971B394#)
  )
 )
```

**(2)** Authorize the mirror with Guix:

```bash
$ guix archive --authorize < /root/berlin.guixsd.org.pub
```

**(2)** Use mirror with Guix:

```bash
$ guix package -i packagename --substitute-urls=https://berlin.guixsd.org
```

### guix refresh

#### guix refresh: peer-certificate-status Throw gnutls-error

When `guix refresh` produces an error, similar to this:

```bash
gnu/packages/admin.scm:2452:13: thermald would be upgraded from 1.7.2 to 1.8
Backtrace:
          16 (primitive-load "/root/.config/guix/current/bin/guix")
In guix/ui.scm:
  1583:12 15 (run-guix-command _ . _)
In ice-9/boot-9.scm:
    829:9 14 (catch _ _ #<procedure 7f3d05aee458 at guix/ui.scm:615…> …)
    829:9 13 (catch _ _ #<procedure 7f3d05aee470 at guix/ui.scm:733…> …)
In guix/scripts/refresh.scm:
   458:12 12 (_)
In srfi/srfi-1.scm:
    640:9 11 (for-each #<procedure 1557b00 at guix/scripts/refresh.…> …)
In guix/scripts/refresh.scm:
    241:2 10 (check-for-package-update #<package rename@1.00 gnu/pa…> …)
In guix/import/cpan.scm:
    286:2  9 (latest-release #<package rename@1.00 gnu/packages/admi…>)
In guix/import/json.scm:
     50:9  8 (json-fetch-alist _)
In ice-9/boot-9.scm:
    829:9  7 (catch srfi-34 #<procedure 2ce9b80 at guix/import/json…> …)
In guix/import/json.scm:
    42:19  6 (_)
In guix/http-client.scm:
    88:25  5 (http-fetch _ #:port _ #:text? _ #:buffered? _ ## _ ## _ ## …)
In guix/build/download.scm:
    403:4  4 (open-connection-for-uri _ #:timeout _ ## _)
    301:6  3 (tls-wrap #<input-output: socket 25> _ ## _)
In ice-9/boot-9.scm:
    829:9  2 (catch tls-certificate-error #<procedure 2ce9880 at gu…> …)
In guix/build/download.scm:
    220:2  1 (assert-valid-server-certificate #<session 372aea0> "fa…")
In unknown file:
           0 (peer-certificate-status #<session 372aea0>)

ERROR: In procedure peer-certificate-status:
Throw to key `gnutls-error' with args `(#<gnutls-error-enum An unimplemented or disabled feature has been requested.> peer-certificate-status)'.
```

To fix this, install `gnutls` with:

```bash
$ guix package -i gnutls
```

#### guix refresh: X.509 certificate verification issue

When you see an error, similar to this:

```bash
$ user@system ~$ guix refresh
Backtrace:
          13 (primitive-load "/home/user/.config/guix/current/bin…")
In guix/ui.scm:
  1583:12 12 (run-guix-command _ . _)
In ice-9/boot-9.scm:
    829:9 11 (catch srfi-34 #<procedure 1839a80 at guix/ui.scm:615:…> …)
    829:9 10 (catch system-error #<procedure 1b1c0f0 at guix/script…> …)
In guix/scripts/refresh.scm:
   458:12  9 (_)
In srfi/srfi-1.scm:
    640:9  8 (for-each #<procedure 1839380 at guix/scripts/refresh.…> …)
In guix/scripts/refresh.scm:
    241:2  7 (check-for-package-update #<package acct@6.6.4 gnu/pac…> …)
In guix/gnu-maintenance.scm:
   561:21  6 (latest-gnu-release _)
   546:16  5 (_)
In ice-9/boot-9.scm:
    829:9  4 (catch srfi-34 #<procedure 1b1c0a0 at guix/http-client…> …)
In guix/http-client.scm:
   182:20  3 (_)
    88:25  2 (http-fetch _ #:port _ #:text? _ #:buffered? _ ## _ ## _ ## …)
In guix/build/download.scm:
    403:4  1 (open-connection-for-uri _ #:timeout _ ## _)
    301:6  0 (tls-wrap #<closed: file 3d22380> _ ## _)

guix/build/download.scm:301:6: In procedure tls-wrap:
X.509 certificate of 'ftp.gnu.org' could not be verified:
  signer-not-found
  invalid
```

or this:

```bash
fatal: unable to access 'https://address.org/': Problem with the SSL CA cert (path? access rights?)
```

This issue is related to SSL certificate verification.

To install fix this, install and configure `nss-certs`:

```bash
$ guix package -i nss-certs
$ export SSL_CERT_DIR="$HOME/.guix-profile/etc/ssl/certs"
$ export SSL_CERT_FILE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
$ export GIT_SSL_CAINFO="$SSL_CERT_FILE"
```

Read more about [X.509 Certificates in the Guix Manual](https://www.gnu.org/software/guix/manual/en/html_node/X_002e509-Certificates.html).

### guix pull

#### guix pull: symlink exists error

Executing `guix pull` command on a non-root user we might receive following error:

```bash
panther@panther ~$ guix pull
Migrating profile generations to '/var/guix/profiles/per-user/panther'...
guix pull: error: symlink: File exists: "/var/guix/profiles/per-user/panther/current-guix"
```

This problem is occurred because of an issue when guix tries to create  symlink
to current profile for user.

a workaround to resolve this issue is to remove current profile symlink, which
is located in `~/.config/guix/current` and relink that using following command:

```bash
ln -s "/var/guix/profiles/per-user/$USER/current-guix" "~/.config/guix/current"
```

*Reference:* [Help-Guix mailing list](https://lists.gnu.org/archive/html/help-guix/2018-11/msg00068.html)

### guix archive

#### guix archive: error: build failed: getting status of `/etc/guix/signing-key.sec'

```bash
guix archive: error: build failed: getting status of `/etc/guix/signing-key.sec': No such file or directory
```

To fix this, generate a new key pair for the daemon. This is a prerequisite before archives can be exported with --export. Note that this operation usually takes time, because it needs to gather enough entropy to generate the key pair. _([Source](https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-archive.html))_

```bash
$ guix archive --generate-key
```

### guix package

#### guix package: error: build failed: some substitutes for the outputs of derivation

When you see an error, similar to this:

```bash
$ guix package -i python2
substitute: updating substitutes from 'https://mirror.hydra.gnu.org'... 100.0%

The following package will be installed:
   python2	2.7.14	/gnu/store/53qclss2ic8lrs4l9778rf4fkr55rg45-python2-2.7.14

substitute: updating substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
substitute: updating substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
substitute: updating substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
substitute: updating substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
substitute: updating substitutes from 'https://mirror.hydra.gnu.org'... 100.0%
The following derivations will be built:
   /gnu/store/gly2wxpgb6amfdwv848c8cd4f81f6h01-profile.drv
   /gnu/store/k0isxpanm0qavrgrbxai70y5fiynb153-info-dir.drv
   /gnu/store/glykncy3qpsdxkxm55cbwb2qym3pnv4p-ca-certificate-bundle.drv
   /gnu/store/c2gzbf55fl7z7wilb4d3hl787v4lzbfq-fonts-dir.drv
   /gnu/store/056fvy2kybsl0iisnvc2k2fhxkjxp71j-python2-2.7.14.drv
   /gnu/store/kwicx940qyyb125v3r8y5f4wikrpsvrz-manual-database.drv
Downloading https://mirror.hydra.gnu.org/guix/nar/gzip/waszs4why44hpha9xlzp7p8fdc577xlm-python2-2.7.14-tk...
guix substitute: error: download from 'https://mirror.hydra.gnu.org/guix/nar/gzip/waszs4why44hpha9xlzp7p8fdc577xlm-python2-2.7.14-tk' failed: 504, "Gateway Time-out"
guix package: error: build failed: some substitutes for the outputs of derivation `/gnu/store/yhmbka6gryhl69432k3krvaz73ym8130-python2-2.7.14.drv' failed (usually happens due to networking issues); try `--fallback' to build derivation from source
```

This could have one of two causes:

1. The package has been modified but a substitute is not yet available (the source has not been build)
2. The mirror is failing (Gateway Time-out)

To fallback, to building unavailable packages locally, do:

```bash
$ guix package -i python2 --fallback
```

If that doesn't work, refresh your package index first:

```bash
$ guix pull
$ guix package -u
$ guix package -i python2
```

#### guix package: error: unpack failed: tar `Operation not permitted` issue

```bash
starting phase `unpack
tar: .: Cannot utime: Operation not permitted
tar: .: Cannot change mode to rwxr-xr-t: Operation not permitted
tar: Exiting with failure status due to previous errors
```

This issue could be related *tarbomb*, and causes when we don't provide a root folder inside package `.tgz` archive files. 

While creating package archive files is not standard, and forces us to apply manual modifications and additional workarounds to fix upcoming issues, we still could create these package for this type of archives, by using `(method url-fetch/tarbomb)` instead of `(method url-fetch)` inside our package definition. 

*Reference:* [Help-Guix mailing list](http://lists.gnu.org/archive/html/help-guix/2019-01/msg00096.html)

#### guix package: installation paths 

During package installation, each installed file, creates a *symbolic link* inside `~/.guix-profile/` based on its relative defined path. 

For example while `~/.guix-profile/share/guile/site/2.2/` is the base path for installed *guile* scripts, we need to install our `.scm` scripts to `share/guile/site/2.2` relative path in *store*. Later during package installation, a *symlink* will create inside current users *guix-profile* path.

*Reference:* [Help-Guix mailing list](http://lists.gnu.org/archive/html/help-guix/2019-01/msg00147.html)

### guix system reconfigure

#### guix system reconfigure: problem on detecting channels

in some cases, users might face issues related to reading custom channels during
system reconfigure:

```scheme
no code for module (px packages accounts).
```

we need to check if the channels file is located in `~/.config/guix/channels.scm`
and it's accessible by current user (reconfigure needs to be performed by `root`
user). later in order fix we need to perform following steps:

- login with `root` user
  - using *Vagrant* as development environment, you can have root access over ssh
    using: `ssh -p 2222 root@127.0.0.1` command
- remove `guix` cache folder located in `/root/.cache/guix/`
- run `guix pull` to get a fresh copy of package repositories from server
- run `guix system reconfigure ...` to reconfigure the based on system
configuration file

### other guix related issues

#### relation between `sudo` command and guix profiles

`guix pull` command updates the `guix` command and package definitions only for
the user it is ran as no matter to run with `sudo` or not.This means that if you
choose to use `guix system reconfigure` in root's login shell, you'll need to
`guix pull` separately.

*Reference:* [regarding commit in Guix repositories](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=6a7f4d89b2029b43b766217d71d5dbbdfcc5fa09)