---
namespace: nginx
description: "Nginx is a web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache."
description-source: "https://en.wikipedia.org/wiki/Nginx"
categories:
  - type:
      - "Webserver"
  - location:
      - "Development"
language: en
---

## Configure Nginx with a self-signed certificate

Login as root before you continue.

```
su - root
```

### Create a certificate

_Be aware: If you want to publish this, you will need to get a certificate issues by an authority such as [Lets Encrypt](https://letsencrypt.org/) (free). Self-signed certificates will produce warnings in almost all browsers. (More on that at the bottom)._

Create a self-signed certificate:

```bash
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out ~/example.crt \
            -keyout ~/example.key
```

### Create a website

Create a folder to hold the files:

```
mkdir -p /src/http/example.com
```
Now either move your static website there, or start one now.

Create an `index.html` file

```
nano /src/http/example.com/index.html
```

with the following content (example from [bulma.io](https://bulma.io/documentation/overview/start/#starter-template)).

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hello Bulma!</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css">
  </head>
  <body>
  <section class="section">
    <div class="container">
      <h1 class="title">
        Hello World
      </h1>
      <p class="subtitle">
        My first website with <strong>Bulma</strong>!
      </p>
    </div>
  </section>
  </body>
</html>
```

### Configure Nginx

To configure this, you will need to do two things:

1. Import the `web` package and service module.
2. Add the `nginx-service-type` to your services

Open `nano /etc/system.scm` to get started:

```scheme
(use-modules (gnu)
             (gnu system)
             (px system)
             ...
             ;; Add this line
             (gnu packages web))

;; Add this line
;; If 'user-service-modules' already exists, just add 'web' to it
(use-service-modules web)

(px-desktop-os
 (operating-system

  ...

))
```

Modify services to look like this:

```scheme
(services (cons* (service nginx-service-type
                                (nginx-configuration
                                 (server-blocks
                                  (list (nginx-server-configuration
                                    (server-name '("example.com"))
                                    (root "/src/http/example.com")
                                    (ssl-certificate "/root/example.crt")
                                    (ssl-certificate-key "/root/example.key"))))))
                %px-desktop-services))
```

### Modify hosts file

To actually test this locally, we need to also modify the hosts file and add `127.0.0.1 example.com`. We also do this in `/etc/system.scm`:

```scheme
...
(px-desktop-os
 (operating-system
  (host-name "panther")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  ;; Add these lines
  (hosts-file
   (plain-file "hosts"
               "
127.0.0.1 localhost panther
::1       localhost panther
127.0.0.1 example.com"))

...
))
```

After reconfiguration, we can test.

```
guix system reconfigure /etc/system.scm
```

### Testing

Just open https://example.com/ in Firefox, skip the certificate warning and you should see the content of your index.html file.

### Automatically get certificates (Lets Encrypt)

If you wanted to actually share this with others, power up a server and use proper certificates; Here's how-to get these automatically: [Certificate Services - guix.gnu.org](https://guix.gnu.org/manual/en/html_node/Certificate-Services.html).

### Clean-up

1. Remove the certificate, key and website `/src/http/example.com/`
2. Revert changes in `/etc/config.scm`
3. Reconfigure

```bash
guix system reconfigure /etc/system.scm
```