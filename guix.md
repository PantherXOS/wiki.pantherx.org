# Usage

## Installing packages

### Installing specific packages

To install a single package or list of packages, including dependencies, issue the following command:

```bash
$ guix package -i package-name1 package-name2 ...
``` 

### Installing package groups

...

## Removing packages

To remove a single package, leaving all of its dependencies installed:

```bash
$ guix package -r package-name
```

To remove a package and its dependencies which are not required by any other installed package: 

```bash
$
```

## Upgrading packages

The following command synchronizes the repository databases and updates the system package references, excluding "local" packages that are not in the configured repositories:

```bash
$ guix pull
```

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
guix system list-generations
```

and initiate a roll-back, to the desired generation

```bash
guix system switch-generation number
```

## Querying package databases

_Guix_ can search for packages in the database, searching both in packages' names and descriptions: 

```bash
$ guix package -s package-name
```

## Additional commands
