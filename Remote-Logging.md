---
namespace: guix
title: Remote Logging (Forward Syslog messages)
categories:
 - type:
   - "Development Documents"
 - location:
   - "Development"
   - "Document"
   - "Log"
language: "en"
---

## Syslog

`syslog` is a standard for message logging. it allows separation between the
software that generates log messages, system that stores them and the the
software that reports and analyze them
([wikipedia]([https://en.wikipedia.org/wiki/Syslog](https://en.wikipedia.org/wiki/Syslog))).

`syslog` is the main logging facility in most Operating systems including
GNU/Linux, BSDs and Mac Os, so we decided to use `syslog` as our log storage
service for _PantherX_.

by default, GuixSD configured `syslog` to log anything (except `mail`) of level
`info` or higher to `/var/log/messages`. if we need `debug` level logs as well,
we should access `/var/log/debug` file.  all `mail` related logs are also stored
in `/var/log/maillog`.


## Forward Log messages

You can forward the log messeges with configuring the `syslog` server. Generally, there are `syslog`, `rsyslog` and `syslog-ng` as syslog daemons. So for remote logging you can:

1. `rsyslog`: As root, edit `/etc/rsyslog.conf` with a text editor. Paste this line at the end: 

```
*.*    @logs.papertrailapp.com:46169
```

2. `syslog-ng`:  As root, edit `/etc/syslog-ng.conf` with a text editor. Find a line starting with source. For example: `source s_sys { .. }`.
At the end of the file, paste this. Replace `s_sys` with the source name above, like "s_sys", "src", "s_all", or "s_local":

```
destination d_papertrail {
  udp("logs.papertrailapp.com" port(46169));
};

# replace "s_sys" with the name you found:
log {
  source(s_sys); destination(d_papertrail);
};
```

3. `syslog`: A few Linux distributions still used GNU `syslogd` until recently. Since GNU `syslogd` can only transmit logs to the default syslog port (and not to a port of your choosing), you can use [`remote_syslog2`](https://github.com/papertrail/remote_syslog2). It's packaged and also is working as a service in PantherX. You can install and run it manually, or configure your system to run it as a service:

```scheme
   (service remote-syslog-service-type)
```

You can also configure the `remote-syslog`. There are `destination-host`, `destination-port`, `hostname`, `log-files` and `package` parameters while
they filled with these default values:

```scheme
(define-record-type* <remote-syslog-service-configuration>
  remote-syslog-service-configuration make-remote-syslog-service-configuration
  remote-syslog-service-configuration?
  (destionation-host  remote-syslog-service-configuration-destionation-host
          (default "logs.papertrailapp.com"))
  (destionation-port  remote-syslog-service-configuration-destionation-port
          (default "46169"))
  (hostname           remote-syslog-service-configuration-host
          (default "$(hostname)"))
  (log-files          remote-syslog-service-configuration-log-files
          (default "/var/log/messages"))
  (package            remote-syslog-service-configuration-package
          (default remote_syslog2)))
```

Therefor, if your want, you can change these values in the configuration, ex:

```scheme
   (service remote-syslog-service-type
                (remote-syslog-service-configuration
                  (destination-host "blob.blob.com")
                  (destination-port "1234")
                  (hostname "MY_SYSTEM")))
```