---
namespace: gulp
description: "gulp is an open-source JavaScript toolkit created by Eric Schoffstall used as a streaming build system in front-end web development."
description-source: "https://en.wikipedia.org/wiki/Gulp.js"
categories:
 - type:
   - "Application"
 - location:
   - "Software"
   - "Command-line"
   - "Automation"
language: en
---

## Installation

In a perfect world, you'd install gulp with guix:

```bash
guix package -i gulp
```

But you'll likely find that gulp has not been packaged yet.

So we'll resort to npm:

```bash
npm install gulp
```

This will install gulp to the current folder, with executable under `node_modules/.bin/gulp`.

## Troubleshooting

### "message: 'Error: write EPIPE', plugin: 'gulp-gm'"

This error is related to a missing graphicsmagick library.

```sh
node_modules/.bin/gulp
[10:15:49] Using gulpfile ~/git/somesite.com/gulpfile.js
[10:15:49] Starting 'default'...
[10:15:49] Starting 'js'...
[10:15:52] Finished 'js' after 2.73 s
[10:15:52] Starting 'css'...
[10:15:53] Finished 'css' after 780 ms
[10:15:53] Starting 'countries'...
[10:15:53] Finished 'countries' after 33 ms
[10:15:53] Starting 'productImages'...
[10:15:53] Finished 'productImages' after 3.32 ms
[10:15:53] Finished 'default' after 3.55 s
{ [Error: Error: write EPIPE]
  message: 'Error: write EPIPE',
  plugin: 'gulp-gm',
  showProperties: true,
  showStack: false,
  __safety: { toString: [Function: bound ] } }
```

Resolve with:

```sh
guix package -i imagemagick graphicsmagick
```
