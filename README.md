# hhenson/hgraph

A [Homebrew](https://brew.sh) tap for the [HGL](https://github.com/hhenson/hgl-project)
compiler, `hgl`, and what it is built on.

```sh
brew install hhenson/hgraph/hgl
```

The formula installs a prebuilt `hgl` with the hgraph C++ SDK it builds
programs against. Nothing is compiled to install it. Running a program on
the C++ target compiles it and requires Apple Clang 21 or later.

| Formula | What it installs | Platforms |
| --- | --- | --- |
| `hgl` | HGL compiler with the hgraph C++ SDK | macOS 26 or later on Apple silicon |

Upgrade with `brew upgrade hhenson/hgraph/hgl`.

Report a problem with `hgl` at
[hhenson/hgl-compiler](https://github.com/hhenson/hgl-compiler/issues), and
one with a formula here.
