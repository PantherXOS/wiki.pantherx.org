---
namespace: qt
description: "Qt package guidelines"
categories:
 - type:
   - "Document"
 - location:
   - "Packaging"
   - "Qt"
language: en
---

## Introduction

QT Applications have build steps nativly like this:

```bash
$ qmake
$ make
$ make install
```

On the other hand, _PantherX_ has some _Build Systems_ for _C/C++_ packages:

1. `gnu-build-system` : `configure & make & make install`.
2. `cmake-build-system` : `cmake & make & make install`.
3. `qt-build-system` : `qmake & make & make install`.
4. `trivial-build-system` : Every thing should be defined in the package definition.

With above descriptions, for packaging a _Qt Application_ For _PantherX_ we should select _1._, _2._ or _3._ and customize/replace some steps in guix build system.

## PantherX Specifics

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

### Examples

1. `qpdfview` - [Package Link](https://git.pantherx.org/development/guix-pantherx/blob/master/px/packages/document.scm#L28)
2. `qview` - [Package Link](https://git.pantherx.org/development/pantherx/blob/px-development-stable-v1/gnu/packages/image-viewers.scm#L454)


## Packaging the applications with QtWebEngine as dependency

If you developed one application which is using the `QtWebEngine` library, you should update the path of `QtWebEngineProcess` in the package definition, like the example:


```scheme
...
      (arguments
        `(#:phases
          (modify-phases %standard-phases
            (add-after 'install 'wrap
              ;; The program fails to find the QtWebEngineProcess program,
              ;; so we set QTWEBENGINEPROCESS_PATH to help it.
              (lambda* (#:key inputs outputs #:allow-other-keys)
                (let ((bin (string-append (assoc-ref outputs "out") "/bin"))
                      (qtwebengineprocess (string-append
                                            (assoc-ref inputs "qtwebengine")
                                            "/lib/qt5/libexec/QtWebEngineProcess")))
                  (for-each (lambda (program)
                              (wrap-program program
                                `("QTWEBENGINEPROCESS_PATH" =
                                  (,qtwebengineprocess))))
                            (find-files bin ".*")))
                #t)))))
...
```

### Examples

You can find many examples in upstream. It's enough to search `qtwebengine` in upstream guix package repository.
