---
namespace: guix
description: "Cuirass is a continuous integration tool for Guix. It can be used both for development and for providing substitutes to others."
description-source: "https://gnu.org/software/guix/manual/en/html_node/Continuous-Integration.html"
categories:
 - type:
   - "Guide"
 - location:
   - "GuixSD"
   - "Server"
   - "Continuous Integration"
language: "en"
---

_GNU Cuirass_ is a Continuous Integration system provided for GuixSD. it could be run manually or as a service on top
of Guix. In this document we will provide instructions about using _Cuirass_ to build a custom package list and how to
setup a _Substitute Server_.

## Cuirass Spec Definition
In order to define build jobs for _Cuirass_, we need to define Specification List, a sample definition is as follows:

```scheme
(list
   '((#:name . "pantherx-packages")
     (#:load-path-inputs . ("guix"))
     (#:package-path-inputs . ("custom-packages"))
     (#:proc-input . "guix")
     (#:proc-file . "build-aux/cuirass/gnu-system.scm")
     (#:proc . cuirass-jobs)
     (#:proc-args . ((subset . "manifests")
                     (manifests . (("config" . "manifest.scm")))
                     (systems . ("x86_64-linux"))))
     (#:inputs . (((#:name . "guix")
                   (#:url . "git://git.savannah.gnu.org/guix.git")
                   (#:load-path . ".")
                   (#:branch . "master")
                   (#:no-compile? . #t))
                  ((#:name . "config")
                   (#:url . "git://git.example.org/config.git")
                   (#:load-path . ".")
                   (#:branch . "ci")
                   (#:no-compile? . #t))
      		      ((#:name . "custom-packages")
      		       (#:url . "git://git.example.org/packages.git")
      		       (#:load-path . ".")
      		       (#:branch . "master")
      		       (#:no-compile? . #t))))))
```

Each _Cuirass_ job consist of a list of `inputs` that needs to load in order to prepare for starting the job
and a `proc` which runs by _Cuirass_.

- `name`: a title for each job that used for identification of _Cuirass_ jobs
- `load-path-inputs`: list of inputs that are needed to run current job successfully
- `package-path-inputs`: _Cuirass_ uses this list to search for package definitions to build
- `proc-input`: the input which job execution process should load from, by default we use `guix` (referring to
official guix repository) input for build
- `proc-file`: location of file which job execution procedure should load from. for Package build procedure,
we use `build-aux/cuirass/gnu-system.scm` as default value
- `proc`: name of Job procedure inside `proc-file`. default value is `cuirass-jobs`
- `proc-args`: arguments we want to pass to job execution procedure
   - `subset`: defines how should cuirass load packages for build. this could be `"manifests"` string, or a
   list of package names we want to build
   - `systems`: list of system architectures to build, (default `x86_64-linux`)
   - `manifests`: pointing to a relative location to based on input and file of manifest which contains
   package list
- `inputs`: list of input definitions for job, each containing following parameters:
   - `name`: name of input
   - `url`: input repository url
   - `branch`: repository branch which input should load from
   - `load-path`: relative path in repository that input should load
   - `no-compile?`: ---


## Running Cuirass manually
In order to run cuirass manually, you need to install `cuirass` package. later you can run it using following command:

```shell
cuirass --specifications=/path/to/spec.scm --database=/path/to/database.db
```

you could also add following command-line arguments:

- `--one-shot`: Evaluate and build jobs only once
- `--cache-directory=DIR`:     Use DIR for storing repository data
- `--fallback`:                Fall back to building when the substituter fails.
- `--specifications=SPECFILE`: Add specifications from SPECFILE to database.
- `--database=DB`:             Use DB to store build results.
- `--ttl=DURATION`:            Keep build results live for at least DURATION.
- `--port=NUM`:                Port of the HTTP server.
- `--listen=HOST`:             Listen on the network interface for HOST
- `--interval=N`:              Wait N seconds between each poll
- `--use-substitutes`:         Allow usage of pre-built substitutes
- `--threads=N`:               Use up to N kernel threads


## Run Cuirass as a Service
In order to run _Cuirass_ as a service, first you need to define job specification, then you need to add it to list of
services inside _System Configuration File_:

```
(define %cuirass-specs
   #~(list ... ))

(operating-system
   ...
   (services (cons*
      ...
		(service cuirass-service-type
         (cuirass-configuration
            (host "0.0.0.0")
            (port 8080)
            (specifications %cuirass-spec)
            (use-substitutes? #t)
            (fallback? #t)))
      ...
   )))
```

to find a detailed description about Cuirass Service Details, you can see
[official document](https://www.gnu.org/software/guix/manual/en/html_node/Continuous-Integration.html)


## Provide web access for built packages
in order to serve built packages for clients, first you need to generate authorization keys on server:

```bash
guix archive --generate-key
```
your generated key is located in `/etc/guix/`.

now you need to add `guix-publish` service as follows:

```
(services (cons*
         ...
		   (service guix-publish-service-type
			    (guix-publish-configuration
			      (host "0.0.0.0")
			      (port 3000)
			      (compression '(("gzip" 9) ("lzip" 9)))))
         ...
         ))
```

## Client Configuration
In order to allow clients to access build server, we need to register server's
public key on clients using `guix archive` command:

```bash
guix archive --authorize < /path/to/build-server-signing-key.pub
```

now we need to modify `guix-daemon` service and add build server's url to that:

```scheme
(append (modify-services %base-services
   (guix-service-type
      config => (guix-configuration
         (substitute-urls '("http://server_url:3000"
                            "https://ci.guix.gnu.org"))))))
```


## Known Issues

### Input Name Issue
There is a weird issue in cuirass, that when we start some input name with `p` letter, cuirass execution will fail:

```
2019-06-25T19:17:35 evaluating spec 'hello-spec'
Backtrace:
          17 (apply-smob/1 #<catch-closure 128b780>)
In ice-9/boot-9.scm:
    705:2 16 (call-with-prompt _ _ #<procedure default-prompt-handle…>)
In ice-9/eval.scm:
    619:8 15 (_ #(#(#<directory (guile-user) 1316140>)))
   293:34 14 (_ #(#(#(#(#(#(#(#(#(#(#(…) …) …) …) …) …) …) …) …) …) …))
    159:9 13 (_ _)
    619:8 12 (_ #(#(#(#<module (#{ g18}#) 1339640>) #<store-co…> …) …))
   626:19 11 (_ #(#(#(#<module (#{ g18}#) 1339640>) #<store-co…> …) …))
In guix/store.scm:
  1794:24 10 (run-with-store _ _ #:guile-for-build _ #:system _ # _)
In guix/channels.scm:
    498:2  9 (_ _)
    455:2  8 (_ _)
In guix/monads.scm:
    482:9  7 (_ _)
In guix/store.scm:
   1667:8  6 (_ _)
In guix/gexp.scm:
    708:2  5 (_ _)
In guix/monads.scm:
    482:9  4 (_ _)
In guix/gexp.scm:
   573:13  3 (_ _)
In guix/store.scm:
  1667:13  2 (_ _)
In guix/gexp.scm:
    210:2  1 (lower-object #f _ #:target _)
   189:36  0 (lookup-compiler #f)

guix/gexp.scm:189:36: In procedure lookup-compiler:
In procedure struct_vtable: Wrong type argument in position 1 (expecting struct): #f

Some deprecated features have been used.  Set the environment
variable GUILE_WARN_DEPRECATED to "detailed" and rerun the
program to get more information.  Set it to "no" to suppress
this message.
2019-06-25T19:17:36 failed to evaluate spec 'hello-spec'
```

for now we don't have any fix for this, and as a workaround, you need to aware about your input names
that not to start with `p` letter.

*Reference:* [Guix-Devel mailing list](https://debbugs.gnu.org/cgi/bugreport.cgi?bug=36378)
