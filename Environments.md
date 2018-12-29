---
---

## Installation

_Environments_ are part of [Guix](/Guix), and installed by default.

## Usage

To launch a new environment, with a single, or multiple packages:

```bash
$ guix environment package-name1 package-name2
```

> guix environment defines the GUIX_ENVIRONMENT variable in the shell it spawns; its value is the file name of the profile of this environment. This allows users to, say, define a specific prompt for development environments in their .bashrc

An active environment is indicated with `[env]` in your command line.

You can browse the current, environment-specific profile using:

```bash
$ ls "$GUIX_ENVIRONMENT/bin"
```

## See also

- [Guix Manual: Invoking guix environment](https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-environment.html)