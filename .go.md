---
namespace: golang
description: "Go is a statically typed, compiled programming language designed at Google. It is syntactically similar to C, but with memory safety, garbage collection, structural typing, and CSP-style concurrency. It is often referred to as Golang because of its former domain name, golang.org, but its proper name is Go."
description-source: "https://en.wikipedia.org/wiki/Go_(programming_language)"
categories:
  - type:
      - "Application"
  - location:
      - "Development"
language: en
---

## Installation

To install _git_ for the current user, run:

```bash
guix package -i gccgo
guix package -i go # to ensure go is up to date
```

`gccgo` actually includes `go@1.16.*`. We install `go` again, to get `1.17.8`.

## Usage

```bash
cd ~/
mkdir go; mkdir go/src; mkdir go/src/hello
cd go/src/hello
go mod init
nano hello.go
```

This part is up to you! When you're done, run:

```bash
go run .
```

## Troubleshooting

### C compiler "gcc" not found

```bash
guix package -i gccgo
guix package -i go # to ensure go is up to date
```

As of May 2022:

```bash
$ gccgo --version version
gccgo (GCC) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ go version
go version go1.17.8 linux/amd64
```

### unknown type name gnuc_va_list

```bash
$ go get golang.org/x/crypto/ssh
go: downloading golang.org/x/crypto v0.0.0-20220427172511-eb4f295cb31f
go: downloading golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1
# runtime/cgo
In file included from libcgo.h:7,
                 from gcc_context.c:8:
/home/franz/.guix-profile/include/stdio.h:52:9: error: unknown type name ‘__gnuc_va_list’
   52 | typedef __gnuc_va_list va_list;
      |         ^~~~~~~~~~~~~~
/home/franz/.guix-profile/include/stdio.h:52:24: error: conflicting types for ‘va_list’; have ‘int’
   52 | typedef __gnuc_va_list va_list;
      |                        ^~~~~~~
In file included from /home/franz/.guix-profile/include/stdarg.h:10,
                 from /home/franz/.guix-profile/include/stdio.h:36,
                 from libcgo.h:7,
                 from gcc_context.c:8:
/home/franz/.guix-profile/include/bits/alltypes.h:326:27: note: previous declaration of ‘va_list’ with type ‘va_list’ {aka ‘__va_list_tag[1]’}
  326 | typedef __builtin_va_list va_list;
      |                           ^~~~~~~
In file included from libcgo.h:7,
                 from gcc_context.c:8:
/home/franz/.guix-profile/include/stdio.h:342:22: error: unknown type name ‘__gnuc_va_list’
  342 |                      __gnuc_va_list __arg);
```

(1) Remove conflicting compiler:

```bash
guix package --list-installed | grep "gcc"
# look out for 'gcc', 'gcc-objc', 'gcc-objc++', 'gcc-toolchain'
```

Remove with:

```bash
guix package -r gcc gcc-objc
```

If you are working with multiple languages, consider using [environments](/Environments/).
