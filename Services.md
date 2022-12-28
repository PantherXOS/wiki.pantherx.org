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

### Example

run a nodejs application with `pm2` which is installed for `panther` user in `/home/panther/example-app`:

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
