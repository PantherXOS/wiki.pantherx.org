# PantherX Wiki

_Once the Wiki is a little more complete, we'll publish it on wiki.pantherx.org._

**Reminder: Update `robots.txt` before launch.**

## Working with the Wiki

To create a new file, use the title as file name, for example: `LXQt.md`.

For Jekyll to pick up the file, add some font matter:

```
---
---
```

## Developing this Wiki

To run this Wiki locally, you need to install `bundle`, `yarn` and `jekyll`.

### Set-up Environment

```bash
$ bundle install
$ npm install
```

### Compile Assets

```bash
$ node_modules/.bin/gulp
```

### Run Site

```bash
$ bundle exec jekyll serve
```