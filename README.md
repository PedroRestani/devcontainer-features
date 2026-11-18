# Owned Dev Container Features
This project Features is a set of reusable 'features'. Quickly add a tool/cli to a development container.

_Features_ are self-contained units of installation code and development container configuration.
Features are designed to install atop a wide range of base container images (this repo focuses on debian-based images).

> This repo follows the [**proposed** dev container feature distribution specification](https://containers.dev/implementors/features-distribution/).
>

### List of Features
- [**firebase-tools**](https://github.com/firebase/firebase-tools): Install Firebase CLI using automatic install script (https://firebase.tools)

## Usage
To reference a feature from this repository, add the desired features to a devcontainer.json.
Each feature has a README.md that shows how to reference the feature and which options are available for that feature.

The example below installs the Firebase CLI declared in the ./src directory of this repository, declared as `firebase-tools`.

See the relevant feature's README for supported options.
```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/PedroRestani/devcontainers-features/firebase-tools:0": {}
    }
}
```