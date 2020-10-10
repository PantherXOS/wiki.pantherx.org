---
namespace: node
description: "npm is a package manager for the JavaScript programming language. npm, Inc. is a subsidiary of GitHub, an American multinational corporation that provides hosting for software development and version control with the usage of Git. It is the default package manager for the JavaScript runtime environment Node.js."
description-source: "https://en.wikipedia.org/wiki/Npm_(software)"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
language: en
---

## Install packages

### Recommended

Go ahead and install node and any packages you may need:

```bash
guix package -i node js-json2
```

You may optionally spawn a environment seperate from your system profile:

```bash
guix environment node js-json2
```

If you insist on 100% purity for development, or testing, do:

```bash
guix environment node js-json2 --pure
```

### Using npm

Go ahead and install node as usual:

```bash
guix package -i node
```

and use it in your projects, as always:

```bash
cd project/
npm install
```

### Using npm for global packages

This is a little tricky; If you have too much time, do make an effort to package whatever CLI libraries that you work with, but are not available on PantherX. Here's how to work with them anyways:

```bash
mkdir ~/.NPM_GLOBAL
cd ~/.NPM_GLOBAL
```

Now install whatever package / CLI you need:

```bash
npm install @vue/cli
npm install @vue/cli-init
```

and add it at the bottom of your your `~/.bash_profile` like so:

```bash
# ~/.bash_profile
alias vue=/home/franz/.NPM_GLOBAL/node_modules/.bin/vue
alias vue-cli/home/franz/.NPM_GLOBAL/node_modules/.bin/vue-cli
```

_Lising each binary manually is a bit of a conservative approach, but may work well if it's mostly self-contained. Like vue CLI._

That's it. You can now run this CLI globally:

```bash
$ vue --version
@vue/cli 4.5.7
```

## Troubleshooting

```bash
npm WARN deprecated fsevents@1.2.13: fsevents 1 will break on node v14+ and could be using insecure binaries. Upgrade to fsevents 2.

> gifsicle@5.1.0 postinstall /home/franz/git/nexinnotech.com/node_modules/gifsicle
> node lib/install.js

  ⚠ Response code 404 (Not Found)
  ⚠ gifsicle pre-build test failed
  ℹ compiling from source
  ✖ Error: Command failed: /bin/sh -c autoreconf -ivf
/bin/sh: autoreconf: command not found
```

Resolve with:

```bash
guix package -i autoconf automake gcc-toolchain glibc gcc-objc++
```
