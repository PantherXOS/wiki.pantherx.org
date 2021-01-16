---
namespace: rust
description: "Rust is a multi-paradigm programming language designed for performance and safety, especially safe concurrency."
description-source: "https://en.wikipedia.org/wiki/Rust_(programming_language)"
categories:
 - type:
   - "Application"
 - location:
   - "Software"
   - "Command-line"
language: en
---

## Installation

Install `rust` with:

```bash
$ guix package -i rust
$ guix install rust:cargo
```

This will give you access to:

- rustc
- cargo

## Usage

To compile a single file:

```bash
rustc run main.rs
```

To create a new project, and run it's content:

```bash
$ cargo new hello_world
     Created binary (application) `hello_world` package
$ cd hello_world
$ cargo run
   Compiling hello_world v0.1.0 (/home/franz/git/hello_world)
    Finished dev [unoptimized + debuginfo] target(s) in 2.47s
     Running `target/debug/hello_world`
Hello, world!
```

## Compilation issues

### error occurred: Failed to find tool. Is `cc` installed?

```bash
export CC='ccmake'
```
