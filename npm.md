---
namespace: node
description: "npm is a package manager for the JavaScript programming language. npm, Inc. is a subsidiary of GitHub, an American multinational corporation that provides hosting for software development and version control with the usage of Git. It is the default package manager for the JavaScript runtime environment Node.js."
description-source: "https://en.wikipedia.org/wiki/Npm_(software)"
categories:
 - type:
   - "Application"
 - location:
   - "Development"
language: en
---

## Install packages

### Recommended

Go ahead and install node and any packages you may need:

```bash
$ guix package -i node js-json2
```

You may optionally spawn a environment seperate from your system profile:

```bash
$ guix environment node js-json2
```

If you insist on 100% purity for development, or testing, do:

```bash
$ guix environment node js-json2 --pure
```

### Using npm

Go ahead and install node as usual:

```bash
$ guix package -i node
```

and use it in your projects, as always:

```bash
$ cd project/
$ npm install
```

### Using npm for global packages

This is a little tricky; If you have too much time, do make an effort to package whatever CLI libraries that you work with, but are not available on PantherX. Here's how to work with them anyways:

```bash
$ mkdir ~/.NPM_GLOBAL
$ cd ~/.NPM_GLOBAL
```

Now install whatever package / CLI you need:

```bash
$ npm install @vue/cli
$ npm install @vue/cli-init
```

and add it at the bottom of your your `~/.bash_profile` like so:

```bash
# ~/.bash_profile
$ alias vue=/home/franz/.NPM_GLOBAL/node_modules/.bin/vue
$ alias vue-cli/home/franz/.NPM_GLOBAL/node_modules/.bin/vue-cli
```

_Lising each binary manually is a bit of a conservative approach, but may work well if it's mostly self-contained. Like vue CLI._

That's it. You can now run this CLI globally:

```bash
$ vue --version
@vue/cli 4.5.7
```

## Develop node applications on PantherX (PostgreSQL, Redis, Nginx)

We'll set these up for local development but with minor modifications you can run this on a server too.

1. PostgreSQL (root)
2. Redis (root)
3. Nginx (root)
4. Hosts file (root)
5. NPM

### Configuration

Login as root before you continue.

```
su - root
```

#### PostgreSQL

To configure this, you will need to do two things:

1. Import the `databases` package and service module.
2. Add the `postgresql-service-type` to your services

Open `/etc/system.scm`:

```scheme
(use-modules (gnu)
             (gnu system)
             (px system)
             ...
             ;; Add this line
             (gnu packages databases))

;; Add this line
;; If 'user-service-modules' already exists, just add 'databases' to it
(use-service-modules databases)

(px-desktop-os
 (operating-system
 
  ...
 
))
```

Modify services:

_Refer to https://www.postgresql.org/docs/13/auth-pg-hba-conf.html for more information on `pg_hba.conf` and database authentication options._

```scheme
(services (cons* (service postgresql-service-type
                          (postgresql-configuration
                           (config-file
                            (postgresql-config-file
                             (hba-file
                              (plain-file "pg_hba.conf"
                         "
local   all     all                     trust
host    all     all     127.0.0.1/32    trust
host    all     all     ::1/128         md5"))))
                             (postgresql postgresql-10)))
                 %px-desktop-services))
```

This will ensure that any user can connect do any database via unix socker or `127.0.0.1` for ease.

#### Redis

All we need to add is `(service redis-service-type)`.

```scheme
(services (cons* (service postgresql-service-type
                          (postgresql-configuration
                           (config-file
                            (postgresql-config-file
                             (hba-file
                              (plain-file "pg_hba.conf"
                         "
local   all     all                     trust
host    all     all     127.0.0.1/32    trust
host    all     all     ::1/128         md5"))))
                             (postgresql postgresql-10)))
                 ;; Add this line
                 (service redis-service-type)
                 %px-desktop-services))
```

#### Nginx

To configure this, you will need to do two things:

1. Generate a certificate
2. Import the `web` package and service module.
3. Add the `nginx-service-type` to your services

**(1)** Create a self-signed certificate:

```bash
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out ~/example.crt \
            -keyout ~/example.key
```

Open `nano /etc/system.scm`:

**(2)** Import the `web` package and service module

```scheme
(use-modules (gnu)
             (gnu system)
             (px system)
              ...
             (gnu packages databases)
             ;; Add this line
             (gnu packages web))

(use-service-modules databases web)

(px-desktop-os
 (operating-system

....

))
```

**(3)** Add the `nginx-service-type` to your services

Modify services to look like this:

_This is where your self-signed certificate and key at `/root/...` is used. (Don't do this in production. Use [Certificate Services](https://guix.gnu.org/manual/en/html_node/Certificate-Services.html) instead.)_

```scheme
(services (cons* (service postgresql-service-type
                          (postgresql-configuration
                           (config-file
                            (postgresql-config-file
                             (hba-file
                              (plain-file "pg_hba.conf"
                         "
local   all     all                     trust
host    all     all     127.0.0.1/32    trust
host    all     all     ::1/128         md5"))))
                             (postgresql postgresql-10)))
                 (service redis-service-type)
                 ;; Add these lines
                 (service nginx-service-type
                          (nginx-configuration
                           (server-blocks
                            (list (nginx-server-configuration
                             (server-name '("example.com"))
                             (ssl-certificate "/root/example.crt")
                             (ssl-certificate-key "/root/example.key")
                             (locations
                               (list
                                 (nginx-location-configuration
                                 (uri "/")
                                 (body '("proxy_pass http://localhost:4000;"))))))))))
                %px-desktop-services))
```

#### Modify hosts file

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

**To apply all these changes**, reconfigure:

```bash
guix system reconfigure /etc/system.scm
```

#### NPM

Now you should have PostgreSQL, Redis and Nginx running.

Go back to your user account.

```bash
exit
```

Install node:

```bash
guix package -i node
```

and run your application (for ex. express server) on port `4000`.

#### Testing

Just open https://example.com/ in Firefox, skip the certificate warning and you should see your application.

To revert, simply remove the changes from `/etc/system.scm` and reconfigure with

```bash
guix system reconfigure /etc/system.scm
```

You can also start and stop or restart services:

```bash
su - root
herd status # get a list of all running services
herd stop nginx
herd start nginx
herd restart nginx
```

## Troubleshooting

```bash
npm WARN deprecated fsevents@1.2.13: fsevents 1 will break on node v14+ and could be using insecure binaries. Upgrade to fsevents 2.

> gifsicle@5.1.0 postinstall /home/franz/git/nexinnotech.com/node_modules/gifsicle
> node lib/install.js

  ⚠ Response code 404 (Not Found)
  ⚠ gifsicle pre-build test failed
  ℹ compiling from source
  ✖ Error: Command failed: /bin/sh -c autoreconf -ivf
/bin/sh: autoreconf: command not found
```

Resolve with:

```bash
$ guix package -i autoconf automake gcc-toolchain glibc gcc-objc++
```
