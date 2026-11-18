#!/bin/bash

set -e

source dev-container-features-test-lib

check "check firebase-tools installed" bash -c "firebase --version"

reportResults
