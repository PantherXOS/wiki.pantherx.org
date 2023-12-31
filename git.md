---
namespace: git
description: "Git is a version-control system for tracking changes in computer files and coordinating work on those files among multiple people. It is primarily used for source-code management in software development, but it can be used to keep track of changes in any set of files. As a distributed revision-control system, it is aimed at speed, data integrity, and support for distributed, non-linear workflows."
description-source: "https://en.wikipedia.org/wiki/Git"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
   - "Version Control System"
language: en
---

## Installation

To install _git_ for the current user, run:

```bash
$ guix package -i git
```

#### Graphical front-ends

## Configuration

## Usage

#### Creating a Git repository

To create a new git repository, in the current directory, do:

```bash
$ git init
```

A message should confirm the creation of the repository:

```bash
Initialized empty Git repository in /root/test/.git/
```

#### Getting a Git repository

To clone an existing _git_ repository, do:

```bash
$ git clone https://github.com/MunGell/awesome-for-beginners.git
```

This will create a new folder `awesome-for-beginners`. To go to the new folder:

```bash
$ cd awesome-for-beginners
```

#### Recording changes

After you've made some changes, commit them to the _git_ repository, to permanently _save_ the current version.

##### Staging changes

To add all changed, files to the commit, do:

```bash
$ git add .
```

To add individual, changed files to the commit, do:

```bash
$ git add file-name
```

To see all files, that will be added to the commit, do:

```bash
$ git status
```

If you like to clear the staging area, and start again, do:

```bash
$ git reset
```

##### Committing changes

To commit the changes you've made, make sure that you've added them to the staging area with `git add .` and reviewed all changes with `git status`. Now go ahead, and commit _(save)_ the changes:

```bash
$ git commit -m "file: revised instructions"
```

It's good practice, to add short but clear commit messages.

## Tips and tricks

#### Using multiple SSH keys

Create `~/.ssh/config` and define all domains, and keys you'd like to use.


```bash
host git.domain1.com
 HostName git.domain1.com
 IdentityFile ~/.ssh/key1
 User git

host git.domain2.com
 HostName git.domain2.com
 IdentityFile ~/.ssh/key2
 User git
```

## Troubleshooting

### Error: gpg failed to sign the data

If you're facing issues signing with gpg, here's what you can do:

```bash
$ git commit -m "initial commit"
error: gpg failed to sign the data
fatal: failed to write commit object
```

Double-check that gpg is working:

```bash
$ echo "test" | gpg --clearsign
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

test
gpg: signing failed: No pinentry
gpg: [stdin]: clear-sign failed: No pinentry
```

_Note: It's not working; Looks like it cannot find pinentry._

### Quick Fix

Find out the location of pinentry:

```bash
# Find out pinentry location
$ which pinentry
/run/current-system/profile/bin/pinentry
```

Stop the running gpg daemon:

```bash
# kill running daemon
pkill gpg-agent
```

Start daemon:

```bash
# run new daemon
gpg-agent --pinentry-program=/run/current-system/profile/bin/pinentry --daemon
```

## See also

- [git website](https://git-scm.com/)
- [git man pages](https://jlk.fjfi.cvut.cz/arch/manpages/man/git.1)
- [git Linux GUI clients](https://git-scm.com/download/gui/linux)
