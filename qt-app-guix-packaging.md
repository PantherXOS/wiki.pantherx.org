---
namespace: QT Application GUIX Packaging
description: "How to package QT Applications for GUIX."
categories:
 - type:
   - "Document"
 - location:
   - "Document"
   - "Qt"
   - "Guix"
   - "Packaging"
language: en
---

# Introduction
QT Applications have build steps nativly like this:

```bash
$ qmake
$ make
$ make install
```

On the other hand, the _GUIX_ has some _Build Systems_ for _C/C++_ packages:

1. `gnu-build-system` : `configure & make & make install`.
2. `cmake-build-system` : `cmake & make & make install`.
3. `trivial-build-system` : Every thing should be defined in the package definition.


With above descriptions, for packaging a _Qt Application_ For _Guix_ we should select _1._ or _2._ and customize/replace some steps in guix build system.

# But How
We can replace some steps in package building/installation. Here is a piece of package definition. In this sample the 
`gnu-build-system` used. And generally two things added to the package definition:

1. Replacing the `configure` step.     
At this step we should run `qmake` - with needed parameters.
 
2. Adding some instruction for correcting the installation path, before starting the `install` step.     
At this step we should modify the installation path in _Makefile(s)_. In this example the `(substitute* ....)` method used for replacing the `out` path
instead of `$INSTALL_ROOT/usr`.

```scheme
(build-system gnu-build-system)
(arguments
 `(#:phases
   (modify-phases %standard-phases
     (replace 'configure
       (lambda _
         (invoke "qmake" "CONFIG+=without_djvu without_cups" "qpdfview.pro")))
     ;; Installation process hard-codes "/usr/bin", possibly
     ;; prefixed.
     (add-before 'install 'fix-install-directory
       (lambda* (#:key outputs #:allow-other-keys)
         (let ((out (assoc-ref outputs "out")))
           (substitute* "Makefile.pdf-plugin" (("\\$\\(INSTALL_ROOT\\)/usr") out))
           (substitute* "Makefile.ps-plugin" (("\\$\\(INSTALL_ROOT\\)/usr") out))
           (substitute* "Makefile.image-plugin" (("\\$\\(INSTALL_ROOT\\)/usr") out))
           (substitute* "Makefile.application" (("\\$\\(INSTALL_ROOT\\)/usr") out))
           #t)))
     )))
```

# Examples:
1. `qpdfview` - [Package Link](https://git.pantherx.org/development/guix-pantherx/blob/master/px/packages/document.scm#L28)
2. `qview` - [Package Link](https://git.pantherx.org/development/pantherx/blob/px-development-stable-v1/gnu/packages/image-viewers.scm#L454)

