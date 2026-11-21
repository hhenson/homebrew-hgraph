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

Upgrade with `brew upgrade hhenson/hgraph/hgl`.

Report a problem with `hgl` at
[hhenson/hgl-compiler](https://github.com/hhenson/hgl-compiler/issues), and
one with a formula here.
