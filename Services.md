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


