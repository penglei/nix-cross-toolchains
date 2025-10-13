# Cross Toolchains Flake

A Nix flake providing cross-compilation toolchains for various target architectures.

## Overview

This flake provides ready-to-use cross-compilation environments for multiple target architectures from different host systems. It automatically sets up the necessary toolchains and static musl variants where available.

## Supported Systems

### `aarch64-darwin` (Apple Silicon Mac):

* aarch64-unknown-linux-gnu

* aarch64-unknown-linux-musl

* x86_64-unknown-linux-gnu

* x86_64-unknown-linux-musl

### `aarch64-linux` (ARM64 Linux):

* x86_64-unknown-linux-gnu

* x86_64-unknown-linux-musl

### `x86_64-linux` (x86_64 Linux):

* aarch64-unknown-linux-gnu

* aarch64-unknown-linux-musl

## Usage

Enter a Cross-Compilation Environment To enter a development shell with cross-compilation tools for a specific target:

```bash
❯ nix develop .#<target-triple>
```

For example, to cross-compile to aarch64-unknown-linux-gnu:


```bash
❯ nix develop .#aarch64-unknown-linux-gnu
```

### Static Musl Targets

For static linking with musl libc, use the -static suffix targets:


```bash
❯ nix develop .#aarch64-unknown-linux-musl-static
#or
❯ nix develop .#x86_64-unknown-linux-musl-static
```

### Default Development Shell

The default shell provides LLVM 18 toolchain:

```bash
nix develop
# or
nix develop .#default
```

## Available Targets

The flake provides development shells for these target triples:

* `aarch64-unknown-linux-gnu`

* `aarch64-unknown-linux-musl`

* `aarch64-unknown-linux-musl-static` (static musl variant)

* `x86_64-unknown-linux-gnu`

* `x86_64-unknown-linux-musl`

* `x86_64-unknown-linux-musl-static` (static musl variant)


Example: Cross-Compiling a C Project

```bash
# Enter cross-compilation environment
❯ nix develop .#aarch64-unknown-linux-musl-static


# Inside the shell, compile for ARM64 Linux
❯ aarch64-unknown-linux-musl-gcc -o hello hello.c

❯ file hello
hello: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, not stripped

```
