# hhenson/hgraph

A [Homebrew](https://brew.sh) tap for the [HGL](https://github.com/hhenson/hgl-project)
compiler, `hgl`, and what it is built on.

```sh
brew install hhenson/hgraph/hgl
```

If Homebrew reports an untrusted formula, grant trust to `hgl` and retry.

```text
Error: Refusing to load formula hhenson/hgraph/hgl from untrusted tap hhenson/hgraph.
```

```sh
brew trust --formula hhenson/hgraph/hgl
brew install hhenson/hgraph/hgl
```

The formula installs a prebuilt `hgl` with the hgraph C++ SDK. Homebrew can
pour the Apple silicon bottle on macOS 26 and compatible newer versions. On
Linux it installs the published archive. The C++ target uses Homebrew's CMake
and Ninja, and requires Apple Clang 21 or later on macOS or Ubuntu's `g++-15`
on Linux.

The Linux release supports x86-64 Ubuntu 26.04 LTS with system glibc 2.43 and
libstdc++. Ubuntu 24.04 ships GCC 13 and glibc 2.39, and Ubuntu 22.04 ships
GCC 11 and glibc 2.35. Both are outside the support floor.

| Formula | What it installs | Platforms |
| --- | --- | --- |
| `hgl` | HGL compiler with the hgraph C++ SDK | macOS 26 or later on Apple silicon and x86-64 Ubuntu 26.04 LTS |
| `hgl-debug` | hgraph's libraries built for debugging, and symbol files for `hgl`'s | macOS 26 or later on Apple silicon |

With `hgl-debug`, a debug build (`hgl run --debug-build`) steps into hgraph's own code, and a debugger names the file and line of hgraph's frames.
Nobody needs it to build or run a program. Install it with `brew install hhenson/hgraph/hgl-debug`.

Upgrade with `brew upgrade hhenson/hgraph/hgl`. With `hgl-debug` installed, upgrade the two together,
`brew upgrade hhenson/hgraph/hgl hhenson/hgraph/hgl-debug`: `hgl` uses only the `hgl-debug` of its own version.

Report a problem with `hgl` at
[hhenson/hgl-compiler](https://github.com/hhenson/hgl-compiler/issues), and
one with a formula here.
