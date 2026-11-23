
# git-flow-next (via Github Releases) (git-flow-next)

Installs a chosen git-flow-next release

## Example Usage

```json
"features": {
    "ghcr.io/PedroRestani/devcontainer-features/git-flow-next:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | git-flow-next [version](https://github.com/gittower/git-flow-next/releases) to install. Accepts semver or release tag | string | latest |

## Supported platforms
This feature is successfully supported and passing tests on:
- [Debian](https://hub.docker.com/_/debian)
- [Debian Devcontainer](https://github.com/devcontainers/images/tree/main/src/base-debian)
- [Alpine Devcontainer](https://github.com/devcontainers/images/tree/main/src/base-alpine)

### [Repository Standard](/README.md#standard-support-for-this-repository), but **Unsupported**
Ideally, these should be supported but are not:
- [Alpine](https://hub.docker.com/_/alpine)

## Git
This feature checks for and installs Git.
If you want a specific version of Git, provide a configured/configurable image or feature to install it.

The [Devcontainer Repository](https://github.com/devcontainers/features) provides a [Git feature](https://github.com/devcontainers/features/tree/main/src/git).


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/PedroRestani/devcontainer-features/blob/main/src/git-flow-next/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
