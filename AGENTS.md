# Agent Guide

- Read `README.md` first. A formula here installs a published release: build nothing from source in a formula.
- A formula's version, URL and checksum change together, to a release that exists.
- Keep host details, credentials, local paths, and private projects out of commits.
- Changes arrive by pull request on a `codex/` branch. Run `brew audit --strict` and `brew test` on a formula you change, and report both with their scope.
