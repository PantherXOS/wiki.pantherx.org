---
namespace: git
description: "Jekyll is a simple, blog-aware, static site generator for personal, project, or organization sites. Written in Ruby by Tom Preston-Werner, GitHub's co-founder, it is distributed under the open source MIT license."
description-source: "https://en.wikipedia.org/wiki/Jekyll_(software)"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
   - "Frameworks"
   - "Web frameworks"
language: en
---

## Installation

### Default

```bash
$ guix package -i jekyll
```

<!-- TODO: Complete instructions to install, and use jekyll -->

### Docker

To get Jekyll to behave in Docker is pretty simple.

Create a Dockerfile:

```Dockerfile
# Dockerfile
FROM starefossen/ruby-node:2-10-slim
WORKDIR /usr/working
COPY Gemfile ./
RUN apt-get update && apt-get install -y \
    graphicsmagick \
    imagemagick \
    dh-autoreconf \
    openssl \
    awscli \
    && aws configure set preview.cloudfront true
RUN gem install bundler jekyll
RUN bundle install
EXPOSE 4000
```

_This image includes a whole bunch of stuff I use for image resizing, uploading and CDN invalidation (AWS CLI). Whatever you don't need, just remove."

To get this working easily, create a docker-compose file:

```yml
# docker-compose.yml
version: '3'
services:
  jekyll:
    build: .
    command: sh -c "bundle exec jekyll serve --host 0.0.0.0"
    network_mode: "host"
    working_dir: /usr/working
    volumes:
      - $PWD:/usr/working
```

A couple of things to look out for:

- `bundle exec jekyll serve --host 0.0.0.0` basically runs jekyll
- `network_mode: "host"` makes this work like running jekyll without Docker
- `$PWD:/usr/working` mounts your working dir to the container

`$PWD` basically grabs the current terminal directory.

**Running**

Now that we're all setup, create a `run.sh` with:

```sh
docker build --tag jekyll_dev .
# docker run --detach --name gi nexinnotech
docker container run -v ${PWD}:/usr/working \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-e AWS_CLOUDFRONT_DISTRIBUTION_ID=${AWS_CLOUDFRONT_DISTRIBUTION_ID} \
-e AWS_DEFAULT_REGION=eu-central-1 \
-it jekyll_dev /bin/bash
```

Before you run this, clean-out everything you don't need! This example includes AWS environment variables for easy deployment, once I'm done with development.

```sh
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_CLOUDFRONT_DISTRIBUTION_ID=...
sh run.sh
```

This will build and install everything, and finally drop you in the container shell.

Here you may do as you please,

- run jekyll with `

As a little bonus, here's my deployment script:

```sh
$ node_modules/.bin/gulp
$ bundle exec jekyll build
$ aws s3 sync _site/ s3://myawesomesite.com --delete
$ aws cloudfront create-invalidation --distribution-id $AWS_CLOUDFRONT_DISTRIBUTION_ID --paths "/*"
```

This "ties" it all together.

#### Issues

If you see errors like this:

```sh
jekyll_1  | bundler: failed to load command: jekyll (/usr/local/bundle/bin/jekyll)
jekyll_1  | Bundler::LockfileError: You must use Bundler 2 or greater with this lockfile.
```

Delete your `Gemfile.lock`

### On-Demand environment

```bash
$ guix package --profile=jekyll --install ruby@2.4.3 jekyll@2.8.3 ruby-jekyll-watch@2.0.0
```

The environment will be stored at `~/jekyll`.

```bash
$ guix package --search-paths --profile=jekyll
```

<!-- TODO: Complete instructions to create on-demand jekyll environment -->

To add more packages to a profile, do:

```bash
$ guix package --profile=jekyll -i package-name
```

**Note: You should run this, in the folder that contains your existing _jekyll_ profile. Otherwise, a new profile will be created.**

### Reproducible environment

Create a new file

```bash
$ nano jekyll-website.scm
```

with the following content:

```scheme
(use-modules (guix packages)
             (guix licenses)
             (guix build-system ruby)
             (gnu packages)
             (gnu packages version-control)
             (gnu packages ssh)
             (gnu packages ruby))

(package
  (name "jekyll-project")
  (version "1.0")
  (source #f) ; not needed just to create dev environment
  (build-system ruby-build-system)
  ;; These correspond roughly to "development" dependencies.
  (native-inputs
   `(("git" ,git)
     ("openssh" ,openssh)
     ("ruby-rspec" ,ruby-rspec)))
  (propagated-inputs
   `(("jekyll" ,jekyll)))
  (synopsis "A jekyll website")
  (description "This is a jekyll example website")
  (home-page "https://example.com")
  (license expat))
```

To initiate the new project environment, run:

```bash
$ guix environment -l jekyll-website.scm
```

You're now 'in' the environment, indicated with a `[env]` in your console.

Normally, we would initiate a new _jekyll_ site using `jekyll new my-site` but that would result in the use of _bundler_, which we won't need, as long as we're working with _guix_.

We've prepared a repository, which contains the result of the command.

```bash
git clone https://git.pantherx.org/published/jekyll-new-site.git
cd jekyll-new-site
```

<!-- TODO: jekyll 3.8.3 | Error:  The minima theme could not be found. Prepare without minima! -->

Now run _jekyll_ as usual:

```bash
$ jekyll serve
```

### Jekyll with bundler

Create a new file

```bash
$ nano jekyll-website.scm
```

with the following content:

```scheme
(use-modules (guix packages)
             (guix licenses)
             (guix build-system ruby)
             (gnu packages)
             (gnu packages version-control)
             (gnu packages ssh)
             (gnu packages ruby))

(package
  (name "jekyll-project")
  (version "1.0")
  (source #f) ; not needed just to create dev environment
  (build-system ruby-build-system)
  ;; These correspond roughly to "development" dependencies.
  (native-inputs
   `(("git" ,git)
     ("openssh" ,openssh)
     ("ruby-rspec" ,ruby-rspec)))
  (propagated-inputs
   `(("bundler" ,bundler)))
  (synopsis "A jekyll website")
  (description "This is a jekyll example website")
  (home-page "https://example.com")
  (license expat))
```

To initiate the new project environment, run:

```bash
$ guix environment -l jekyll-website.scm
```

Create a new folder, and initialize _bundler_:

```bash
$ mkdir my-site && cd my-site
$ bundle init
```

Set _bundler_ to use `vendor/bundle` for gem files:

```bash
$ bundle install --path vendor/bundle
```

Add add _jekyll_:

```bash
$ bundle add jekyll
```

Now you can create the scaffolding site using:

```bash
$ bundle exec jekyll new --force --skip-bundle .
$ bundle install
```

To run _jekyll_:

```bash
$ bundle exec jekyll serve
```

<!-- TODO: bundler: command not found: jekyll -->

## Troubleshooting

### Errno::EACCES: Permission denied @ rb_sysopen - ~/my-site/Gemfile

Check file permissions with:

```bash
$ ls -la ~/my-site/
```

and add _read_ and _write_ permissions as necessary:

```bash
$ chmod +rw ~/my-site/Gemfile
```

## See also

- [Ruby on Guix](https://dthompson.us/ruby-on-guix.html)
