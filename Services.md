---
namespace: services
description: "System services provided by PantherX channel"
description-source: "https://channels.pantherx.org/pantherx-extra.git/"
categories:
 - type:
   - "Operating system"
   - "services"
 - location:
   - "General"
   - "Services"
language: en
---

## `nebula-service-type`

This service is located in `(px services networking)` module.

### default configuration

```scheme

(services (cons*
           (service nebula-service-type)
           ...))
```

### multiple networks support 

```scheme
(services (cons*
           (service nebula-service-type
                    (list (nebula-configuration
                           (provision '(nebula-1))
                           (config-path "/etc/nebula/network1/config.yml"))
                          (nebula-configuration
                           (provision '(nebula-2))
                           (config-path "/etc/nebula/network2/config.yml"))))
           ...))
```

### Support for inline configuration

```scheme
(define %nebula-configuration
  (plain-file "nebula.yml"
    "---
pki:
  ca: /etc/nebula/certs/ca.crt
  cert: /etc/nebula/certs/host.crt
  key: /etc/nebula/certs/host.key
..."))

(px-server-os
  (operating-system
    ...
    (services (cons*
               (service nebula-service-type
                        (list (nebula-configuration
                               (provision '(nebula-1))
                               (config-path %nebula-configuration))))
               ...))))
```

more details about Nebula network can be found [here](https://wiki.pantherx.org/Nebula-Network/).


## `px-server-launcher-service-type`

### Usage

1. define the launcher configuration
   ```scheme
   (define %launcher-configuration
     (px-server-launcher-configuration
       (user "panther")  ;; optional, default=panther
       (group "users")   ;; optional, default=users
       (cwd "/path/to/working/directory") ;; optional, default=#f
       (executable "/path/to/executable/file")
       (args '())        ;; optional, list of arguments pass to the executable
       ))
   ```    
2. add service to system config
   ```scheme
   (services (cons*
              (service px-server-launcher-service-type
                       %launcher-configuration)
              ...))
   ```

### Examples

1. run with `npm` command:

```scheme
(services (cons*
           (service px-server-launcher-service-type
                    (px-server-launcher-configuration
                      (cwd "/home/panther/example-app")
                      (executable "npm")
                      (args '("start"))))
           ...))
```

2. run with `pm2` installed locally on the application directory:

```scheme
(services (cons*
           (service px-server-launcher-service-type
                    (px-server-launcher-configuration
                      (cwd "/home/panther/example-app")
                      (executable "./node_modules/.bin/pm2")
                      (args '("start" "ecosystem.config.js"))))
           ...))
```

3. run without changing the current working directory:

```scheme
(services (cons*
           (service px-server-launcher-service-type
                    (px-server-launcher-configuration
                      (executable "/home/panther/example-app/node_modules/.bin/pm2")
                      (args '("start" "/home/panther/example-app/index.js"))))
           ...))
```

## `create-swap-space-service`

This service checks if  the `/swapfile` is initialized and creates it with the given size if not.

```scheme
(services (cons*
           (create-swap-space-service "2G") ;; size of the swap file
           ...))
```

## `rsyslog-service-type`

This service adds a new `rsyslog` daemon with provided configuration to the system.


### Default configuration

in order to add the service with default configuration:

```scheme
(services (cons*
           (service rsyslog-service-type)
           ...))
```

### Custom configuration

in order to modify the default configuration, first we create the configuration file:

```scheme
(define %rsyslog-configuration
  (plain-file "rsyslog.conf"
    "..."))
```

then we modify the service configuration as follows:

```scheme
(services (cons*
           (service rsyslog-service-type
                    (rsyslog-configuration
                      (config-file %rsyslog-configuration)))
           ...))
```

### Add log forwarding

in order to add log forwarding to a remote server, we need to append forwarding rules to the default configuration:

```scheme
(define %remote-rsyslog-config-file
  (plain-file "remote-rsyslog.conf"
    (string-append %rsyslog-default-config "\n\n"
	  "$PreserveFQDN on

$DefaultNetstreamDriverCAFile /etc/rsyslog/ca.pem

$DefaultNetstreamDriver gtls
$ActionSendStreamDriverMode 1
$ActionSendStreamDriverAuthMode anon

*.* @@(o)log.example.com:1234
")))
```

then modify the service based on what mentioned in [custom configuration](#custom-configuration) section.
