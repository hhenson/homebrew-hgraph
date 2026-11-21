# hhenson/hgraph

A [Homebrew](https://brew.sh) tap for the [HGL](https://github.com/hhenson/hgl-project)
compiler, `hgl`, and what it is built on.

```sh
brew install hhenson/hgraph/hgl
```

The formula installs a prebuilt `hgl` with the hgraph C++ SDK it builds
programs against. Nothing is compiled to install it. Running a program on
the C++ target compiles it, which needs the platform's C++ compiler.

| Formula | What it installs | Platforms |
| --- | --- | --- |
| `hgl` | The HGL compiler | macOS on Apple silicon; Linux to follow |

No release is published yet: the formula arrives with the first one.

Report a problem with `hgl` at
[hhenson/hgl-compiler](https://github.com/hhenson/hgl-compiler/issues), and
one with a formula here.
