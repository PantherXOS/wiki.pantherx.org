# Installation

## Global Installation

## User Profile Installation

To install _weston_, run:

```bash
$ guix package -i weston
```

# Starting the desktop

## From terminal

To launch _weston_, we need to set a number of environment variables:

```bash
$ export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
$ echo $XDG_RUNTIME_DIR
$ /tmp/0-runtime-dir
$ mkdir "${XDG_RUNTIME_DIR}"
$ chmod 0700 "${XDG_RUNTIME_DIR}"
```

Now launch _weston_:

```bash
$ weston-launch
```

## Graphical login

# Configuration

## Use a different window manager

## Autostart

## Set-up environment variables

## Editing the Application Menu

# Troubleshooting

## Desktop icons are grouped together

# Tips and tricks

## Customizing Leave

# See also
