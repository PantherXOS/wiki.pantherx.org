# Usage

## Installing packages

### Installing specific packages

To install a single package or list of packages, including dependencies, issue the following command:

```bash
$ guix package -i package-name1 package-name2 ...
```

#### Install specific package version

```scheme
emacs
gcc-toolchain@7
gcc-toolchain:debug
```

## Removing packages

To remove a single package:

```bash
$ guix package -r package-name
```

## Upgrading packages

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

### Upgrading the system

To perform a system update:

```bash
$ guix system reconfigure /etc/config.scm
```

### Roll-back a system upgrade

To roll back your system, list the available system generations:

```bash
$ guix system list-generations
```

and initiate a roll-back, to the desired generation:

```bash
$ guix system switch-generation number
```

## Querying package channels

_Guix_ can search for packages in the channel, searching both in packages' names and descriptions:

```bash
$ guix package -s package-name
```

To show more information about an individual package:

```bash
$ guix package --show=package-name
```

### Add a new package channel

Channels specify Git repositories where `guix pull` looks for updates to Guix and external package repositories. By default guix pull reads `~/.config/guix/channels.scm`; with -C it can take channel specifications from a user-supplied file that looks like this:

```scheme
(cons (channel
       (name ’guix-hpc)
       (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
       (branch "master"))
      %default-channels)
```

## Cleaning the package cache

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

## Additional commands

### Developing Packages

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

### Creating Application Bundles

To create a tarball:

```bash
$ guix pack spec ...
```

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

To create a tarball where _/bin_ symlinks to the packages _bin_ directory:

```bash
$ guix pack -S /bin=bin spec ...
```

To create a package from manifest in _file_:

```bash
$ guix pack -m file
```

### Creating Environments

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
