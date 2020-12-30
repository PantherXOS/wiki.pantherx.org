---
namespace: guix-import
description: "guix import command is a useful for people who would like to add a package to the distribution with as little work as possible."
description-source: "https://guix.gnu.org/manual/en/html_node/Invoking-guix-import.html"
categories:
 - type:
   - "Application"
 - location:
   - "Software"
   - "Command-line"
   - "Package managers"
language: en
---

# Overview    

`guix import` command is a useful for people who would like to add a package to the distribution with as little work as possible. The command knows of a few repositories from which it can “import” package metadata. The result is a package definition, or a template thereof, in the format we know.

The general syntax is: 

```bash
guix import importer options ...
```

## Supported importers
* gnu
* pypi
* gem
* cpan
* cran
* texlive
* json
* nix
* hackage
* stackage
* elpa
* crate
* opam

## Example

```bash
guix import pypi etebase
```

The output:

```scheme
(package
  (name "python-etebase")
  (version "0.31.2")
  (source
    (origin
      (method url-fetch)
      (uri (pypi-uri "etebase" version))
      (sha256
        (base32
          "1phgyk2w6xx5pqpp8hv3dbszsv0l60ncdxrjvb66h1lyp79imh3j"))))
  (build-system python-build-system)
  (propagated-inputs
    `(("python-msgpack" ,python-msgpack)))
  (home-page
    "https://github.com/etesync/etebase-py")
  (synopsis "Python client library for Etebase")
  (description "Python client library for Etebase")
  (license #f))
```

* You can run `import` command recursively by `-r` option:

```bash
guix import crate rand -r
```

* You can run `import` command for specific version:

```bash
guix import crate rand@0.7.3
```


## References:    

* [Invoking guix import](https://guix.gnu.org/manual/en/html_node/Invoking-guix-import.html)
