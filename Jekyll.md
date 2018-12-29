---
---

## Installation

### Default

```bash
guix package -i jekyll
```

<!-- TODO: Complete instructions to install, and use jekyll -->

### On-Demand environment

guix package --profile=jekyll --install ruby@2.4.3 jekyll@2.8.3 ruby-jekyll-watch@2.0.0

The environment will be stored at `~/jekyll`

guix package --search-paths --profile=jekyll

<!-- TODO: Complete instructions to create on-demand jekyll environment -->

To add more packages to a profile, do:

```bash
$ guix package --profile=jekyll -i package-name
```

**Note: You should run this, in the folder that contains your existing _jekyll_ profile. Otherwise, a new profile will be created.

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
jekyll serve
```

## See also

- [Ruby on Guix](https://dthompson.us/ruby-on-guix.html)