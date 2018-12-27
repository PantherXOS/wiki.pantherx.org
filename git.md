
# Installation

To install _git_ for the current user, run:

```bash
$ guix package -i git
```

## Graphical front-ends

# Configuration

# Usage

## Creating a Git repository

To create a new git repository, in the current directory, do:

```bash
$ git init
```

A message should confirm the creation of the repository:

```bash
Initialized empty Git repository in /root/test/.git/
```

## Getting a Git repository

To clone an existing _git_ repository, do:

```bash
$ git clone https://github.com/MunGell/awesome-for-beginners.git
```

This will create a new folder `awesome-for-beginners`. To go to the new folder:

```bash
$ cd awesome-for-beginners
```

## Recording changes

After you've made some changes, commit them to the _git_ repository, to permanently _save_ the current version.

### Staging changes

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

### Committing changes

To commit the changes you've made, make sure that you've added them to the staging area with `git add .` and reviewed all changes with `git status`. Now go ahead, and commit _(save)_ the changes:

```bash
$ git commit -m "file: revised instructions"
```

It's good practice, to add short but clear commit messages.

### Revision selection

### Viewing changes

## Undoing things

## Branching

## Collaboration

### Pull requests

### Using remotes

### Push to a repository

### Dealing with merges

## History and versioning

### Searching the history

### Tagging

### Organizing commits

# Tips and tricks

## Using git-config

## Adopting a good etiquette

## Speeding up authentication

## Protocol defaults

## Bash completion

## Git prompt

## Visual representation

## Commit tips

## Signing commits

## Working with a non-master branch

## Directly sending patches to a mailing list

## When the remote repo is huge

### Simplest way: fetch the entire repo

### Partial fetch

### Get other branches

### Possible Future alternative

# See also

- [git website](https://git-scm.com/)
- [git man pages](https://jlk.fjfi.cvut.cz/arch/manpages/man/git.1)
- [git Linux GUI clients](https://git-scm.com/download/gui/linux)
