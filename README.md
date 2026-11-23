# hhenson/hgraph

A [Homebrew](https://brew.sh) tap for the [HGL](https://github.com/hhenson/hgl-project)
compiler, `hgl`, and what it is built on.

```sh
brew install hhenson/hgraph/hgl
```

The formula installs a prebuilt `hgl` with the hgraph C++ SDK. Homebrew can
pour the Apple silicon bottle on macOS 26 and compatible newer versions.
Running a program on the C++ target compiles it with Apple Clang 21 or later
and uses the CMake and Ninja installed by Homebrew.

| Formula | What it installs | Platforms |
| --- | --- | --- |
| `hgl` | HGL compiler with the hgraph C++ SDK | macOS 26 or later on Apple silicon |
| `hgl-debug` | hgraph's libraries built for debugging, and symbol files for `hgl`'s | macOS 26 or later on Apple silicon |

With `hgl-debug`, a debug build (`hgl run --debug-build`) steps into hgraph's own code, and a debugger names the file and line of hgraph's frames.
Nobody needs it to build or run a program. Install it with `brew install hhenson/hgraph/hgl-debug`.

Upgrade with `brew upgrade hhenson/hgraph/hgl`. With `hgl-debug` installed, upgrade the two together,
`brew upgrade hhenson/hgraph/hgl hhenson/hgraph/hgl-debug`: `hgl` uses only the `hgl-debug` of its own version.

Report a problem with `hgl` at
[hhenson/hgl-compiler](https://github.com/hhenson/hgl-compiler/issues), and
one with a formula here.
