---
namespace: guix
description: "An important part of preparing an operating-system declaration is listing system services and their configuration."
description-source: "https://guix.gnu.org/manual/en/html_node/Services.html"
categories:
 - type:
   - "System Configuration"
 - location:
   - "Services"
   - "guix"
   - "configuration"
language: en
---

## General routes about service definition

in order to submit a new `system service` for shepherd, we need to define a `service-type`
record containing  list of `extensions, required to start service:

```scheme
(define my-service-type
  (service-type (name 'my-service-name)
                (extensions
                  (list (service-extension ...)
                        (service-extension ...)))))
```

each item in `extensions` list extends shepherd definition of regarding extension.

for example to extend `shepherd-root-service-type` we need to define our extended
definition of based on our service:

```scheme
(define my-shepherd-service
  (list (shepherd-service
          ...)))
```

then we use this definition in our service as follows:

```scheme
  ...
  (extensions
    (list (service-extension shepherd-root-service-type
                             my-shepherd-service)
          (service-extension ...)))))
```

**Note:** a series of mostly used service extensions will be describe in later sections.

we also might need to define some part of our service configurable,  so we need to
define a configuration record for our service, using `define-record-type*` method
located in `guix records` module:

```scheme
(define-record-type* <myservice-configuration>
  myservice-configuration make-myservice-configuration
  myservice-configuration?
  (param1   (myservice-configuration-param1
            (default ...))
  (param2   (myservice-configuration-param2)
  ...)))
```

as a summary, our full service definition could be as follows:

```scheme
(define-module (path to module)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (ice-9 match)
  #:export (myservice-configuration
            myservice-service-type))

(define-record-type* <myservice-configuration>
  myservice-configuration make-myservice-configuration
  myservice-configuration?
  (param1 myservice-configuration-param1
          (default "foo")))

(define myservice-shepherd-service
  (match-lambda
    (($ <myservice-configuration> param1)
      (list (shepherd-service
              (provision '(myservice))
              (documentation "description about service")
              (requirement '())  ; services need to be started before current service
              (start #~(make-forkexec-constructor
                        (list (string-append #$service-package "/bin/exe-name")
                              "-foo" "-bar" ; list of command line arguments
                          )))
              (stop #~(make-kill-destructor)))))))

(define myservice-service-type
  (service-type
    (name 'myservice)
    (extensions (list (service-extension shepherd-root-service-type
                                         myservice-shepherd-service)))
    (default-value (myservice-configuration))))
```

## Service Extensions

### `shepherd-root-service-type`

this service represents a service that managed by shepherd, extending this service
is required, if we want to define a custom service from scratch.

important service parameters we usually use are as follows:

- `provision`: defines the service name
- `requirement`: list of services required to be started prior than our service
- `start`: procedure to run on service start
- `stop`: procedure to run on service stop
- `on-shot?`: `default: #f` - stop service after successful execution of `start`

for a full list of `shepherd-service` parameters, you can check [official document](https://guix.gnu.org/manual/en/html_node/Shepherd-Services.html).

### `account-service-type`

defines the list of `user-account` and `user-group` objects that should be created
during service configuration.

```scheme
(define %myservice-accounts
  (list (user-group (name "mygroup"))
        (user-account (name "myuser")
                      (group "mygroup")
                      (comment "my service user")
                      (supplementary-groups '("users" "video")))))

(define myservice-service-type
  (service-type
    (name 'myservice)
    (extensions (list ...
                      (service-extension account-service-type
                                         %myservice-accounts)))))
```

### `activation-service-type`

this procedure provides a `gexp` that runs on service activation, eg. during
boot time or system reconfigure. in following example we create base config folder
during system reconfigure / boot and set proper permission for it.

```scheme
(define (myservice-activation config)
  (with-imported-modules '((guix build utils))
    #~(begin
        (use-modules (guix build utils))
        (let ((user (getpw #$(myservice-configuration-user config)))
              (directory "/path/to/config/directory"))
          (mkdir-p directory)
          (chown directory (passwd:uid %user) (passwd:gid %user))))))

(define myservice-service-type
  (service-type
    (name 'myservice)
    (extensions (list ...
                      (service-extension activation-service-type
                                         myservice-activation)))))
```

## Service definition notes

### Service `start` procedure

a common way to create service `start` procedure is to use the `make-forkexec-constructor`
procedure, this procedure that initiates the environment and run provided command
on service start. this procedure takes the command as a `list` of strings, plus
a series or optional keys to configure the environment for service to start:

- `command`: command to run on service start provided as `list`
- `[#:user #f]`: user which service is started by (start as `root` of sets to `#f`)
- `[#:group #f]`: group which service is started by (start as `root` of sets to `#f`)
- `[#:log-file #f]`: when it sets,  standard output and error redirects to that
- `[#:directory (default-service-directory)]`: set the current directory for
  service to start
- `[#:file-creation-mask #f]`: set the file creation mask for service
- `[#:environment-variables (default-environment-variables)]`: rests the environment
  variables for service to the provided list

## Additional resources

- [*Service Definition* section in official Guix manual](https://guix.gnu.org/manual/en/html_node/Defining-Services.html)
- [Blog post about define system services for Guix](https://www.mndet.net/2016/05/04/guixsd-system-service.html)
- [Shepherd document about service start/stop procedure methods](https://www.gnu.org/software/shepherd/manual/html_node/Service-De_002d-and-Constructors.html)
