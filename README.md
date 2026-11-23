# Common Dev Container Features
This project Features is a set of reusable 'features'. Quickly add a tool/CLI to a development container.

_Features_ are self-contained units of installation code and development container configuration.
Features are designed to install atop a wide range of base container images.

Most of this repo features focus on Debian and Alpine-based  images,
with exceptions to tools that should be available on a majority of development environments
(e.g. Git extensions)

> This repo follows the [**proposed** devcontainer feature distribution specification](https://containers.dev/implementors/features-distribution).
>

## Targeted platforms
This repo currently targets to make features available to Linux images, primarily Alpine and Debian-based ones,
since those are used in the base images[<sup>[Alpine]</sup>](https://github.com/devcontainers/images/tree/main/src/base-alpine)[<sup>[Debian]</sup>](https://github.com/devcontainers/images/tree/main/src/base-debian)
for [devcontainers/images repository](https://github.com/devcontainers/images).

_Feel free to request support, fork and/or contribute to this repository to increase supported platforms_

<!-- Order alphabetically -->
### Standard Support for this Repository
- [Alpine](https://hub.docker.com/_/alpine)
- [Alpine Devcontainer](https://github.com/devcontainers/images/tree/main/src/base-alpine)
- [Debian](https://hub.docker.com/_/debian)
- [Debian Devcontainer](https://github.com/devcontainers/images/tree/main/src/base-debian)

_Check each feature README to confirm platform support_

## Usage
To reference a feature from this repository, add the desired features to a devcontainer.json ([see example](#ref-example)).
Each feature has a README.md that shows how to reference the feature and which options are available for that feature.

<!-- Order alphabetically -->
### List of Features
- [**git-flow-next**](https://github.com/gittower/git-flow-next): Install git-flow-next from Github Releases
- [**firebase-tools**](https://github.com/firebase/firebase-tools): Install Firebase CLI using [automatic install script](https://firebase.google.com/docs/cli?hl=pt-br#mac-linux-auto-script)
---

<h4 id="ref-example">Referencing example</h4>

The example below installs the Firebase CLI declared in the ./src directory of this repository, declared as `firebase-tools`.

See the relevant feature's README for supported options.
```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/PedroRestani/devcontainers-features/firebase-tools:1": {}
    }
}
```

## Contribute
Anyone may contribute to the repository by requesting feature support, creating issues and/or pull requests.
For direct code changes, create a fork and pull request to this repository <span style="font-size: .6em">or just steal the code if you really need it. <span style="font-size: .8em">That's what the license is for</span><span>

**Follow the [devcontainer feature distribution specification](https://containers.dev/implementors/features-distribution) to make changes to code.**

### Contributors
<!--
    If you're contributing to the PedroRestani/devcontainer-features repository directly,
    add yourself to the list of contributors.
    
    Order alphabetically
-->
**Currently solo mantained**
