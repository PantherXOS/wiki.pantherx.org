---
namespace: guix
title: Standard Log Format for PantherX Applications
categories:
 - type:
   - "Development Documents"
 - location:
   - "Development"
   - "Document"
   - "Log"
language: "en"
---

Since PantherX Devices are spread all over the world, we have to define facilities
for trace issues remotely. having a unified log format could help us to trace and
debug this issues faster and easier.

In this document we define a standard way to unify PantherX Application log
creation and storage.

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

## Log Message Format

In order to have a meaningful log file to be useful in later use, we need to
specify a series of rules to follow for our log messages. following these rules
could help us understand and fix issues faster and easier.

### Message format rules

 1. Log Messages need to specify exact location of message in code.
 2. Since `syslog` doesn't support log level grouping, so we need to specify log
levels internally inside our submitted messages.
 3. Avoid multiline logs, since they often get split up on the way to the log collector.
 4. ... [this list needs to be completed] ...

## Log New Messages

`syslog` has libraries for many programming languages, since most of
_PantherX Applications_ are based on `C++` and `Python` we only cover these two:

- [syslog usage in C++](#syslog-usage-in-c)
- [syslog usage in Python](#syslog-usage-in-python)

### Syslog usage in C++

in order to have `syslog` enabled in `C++` applications we need to include
`<syslog.h>` header file. first of all we need initiate logger with `openlog`
method. submit logs using `syslog` method and close our logger using `closelog`
method.  here is a short description about `syslog` related methods:

#### Open connection to a Syslog service

we need to (re)open a connection to `syslog` service, prior to submit log messages
using `openlog` method. [more info](https://www.gnu.org/software/libc/manual/html_node/openlog.html#openlog)

```cpp
void openlog (const char *ident, int  option, int  facility)
```

- `*ident`:  string that identifies the current log component, this could be name
of application that submits the log messages.
- `option`: mask variable that holds options about how logs should submit to
`syslog` service.

| Option     | Description |
| ---------- | ----------- |
| LOG_CONS   | Write directly to system console if there is an error while sending to system logger.|
| LOG_NDELAY | Open the connection immediately |
| LOG_NOWAIT | Don't wait for child processes that may have been created while logging the message.|
| LOG_ODELAY | Opening of the connection is delayed until `syslog()` is called. |
| LOG_PERROR | (Not in POSIX.1-2001 or POSIX.1-2008.) Print to `stderr` as well.|
| LOG_PID    | Include PID with each message. |

- `facility`: pointed to the default facility that log messages should submit to

| Facility     | Description |
| ------------ | ----------- |
| LOG_AUTH     | security/authorization messages |
| LOG_AUTHPRIV | security/authorization messages (private) |
| LOG_CRON     | clock daemon (**cron**  and  **at**) |
| LOG_DAEMON   | system daemons without separate facility value |
| LOG_FTP      | ftp daemon |
| LOG_KERN     | kernel messages (these can't be generated from user processes) |
| LOG_LOCAL0 through  LOG_LOCAL7 | reserved for local use |
| LOG_LPR      | line printer subsystem |
| LOG_MAIL     | mail subsystem |
| LOG_NEWS     | USENET news subsystem |
| LOG_SYSLOG   | messages generated internally by **syslogd** |
| LOG_USER     | (default) generic user-level messages |
| LOG_UUCP     | UUCP subsystem |

#### Submit Log Messages

in order to submit a new message, we need use `syslog` method . [more info](https://www.gnu.org/software/libc/manual/html_node/syslog_003b-vsyslog.html#syslog_003b-vsyslog)

```cpp
void syslog (int  facility_priority, const char *format, …)
void vsyslog (int  facility_priority, const char *format, va_list  arglist)
```

- `facility_priority`:  indicates the _facility_ and _priority_ which the log
message should submitted to. `LOG_MAKEPRI(facility, priority)` macro is used to
create proper value for this parameter.

| Log Level   | Description |
| ----------- | ----------- |
| LOG_EMERG   | system is unusable |
| LOG_ALERT   | action must be taken immediately |
| LOG_CRIT    | critical conditions |
| LOG_ERR     | error conditions |
| LOG_WARNING | warning conditions |
| LOG_NOTICE  | normal, but significant, condition |
| LOG_INFO    | informational message |
| LOG_DEBUG   | debug-level message |

- `format`: log message format string
- `...`: log message format arguments
- `arglist`: variable  list specified as format arguments

#### Close Connection to Syslog service

close already opened connection to `syslog` service using `closelog` method.
[more info](https://www.gnu.org/software/libc/manual/html_node/closelog.html#closelog)

```cpp
void closelog (void)
```

#### Provide Mask about logs the we want to ignore for send

in order to reduce the amount of log messages that we send to `syslog` service,
we can set a default mask to ignore them locally using `setlogmask` method. this
could be used to reduce the amount of submitted logs in _Production_ mode in
comparison to _Debug_ mode. [more info](https://www.gnu.org/software/libc/manual/html_node/setlogmask.html#setlogmask)

```cpp
int setlogmask (int  mask)
```

- `mask`: integer value indicating about logs that need to be uploaded to `syslog`.
  - we need to use `LOG_MASK` macro to specify various log levels:
  `LOG_MASK(LOG_EMERG) | LOG_MASK(LOG_ERROR)`
  - alternatively we could use `LOG_UPTO` macro to ignore levels greater than specified
  level: `LOG_UPTO(LOG_WARNING)`

### syslog usage in Python

in order to use syslog inside python scripts we need to import `syslog` module to
our code. similar to C++ usage, first we need to initiate our `syslog` client using
`openlog` method, send log messages using `syslog` method and close our logger client
using `closelog` method. [reference](https://docs.python.org/3.7/library/syslog.html)

#### Open Syslog connection

we need to open connection to syslog service using `openlog` method:

```python
syslog.openlog([ident[,  logoption[,  facility]]])
```

- `ident`: optional param that prepends to every messages. default value for this
parameter is `sys.argv[0]`
- `logoption`: similar to C++ definition, this parameter holds bitwise mask for
syslog connection
- `facility`: default facility that logs should send to

#### Send Log Messages

in order to send log messages to syslog service, we need to use `syslog` method:

```python
syslog.syslog(message)
syslog.syslog(priority, message)
```

- `priority`: bitwise mask for level and facility of message we want to send
- `message`:  string message that we want to send

#### Close Logger

in order to close already opened syslog connection, we use `closelog` method:

```python
syslog.closelog()
```

#### Provide Mask for log levels to ignore

Similar to C++ definition if we want to reduce the amount of log messages that we
send to syslog service, we can set a default mask to ignore them locally using
`setlogmask` method.

```python
syslog.setlogmask(maskpri)
```

- `mask`: indicates maximum level of logs that need to be uploaded to `syslog`.
  - `LOG_MASK` method is used to specify various log levels.
  - `LOG_UPTO` method is used to ignore levels greater than specified level.
