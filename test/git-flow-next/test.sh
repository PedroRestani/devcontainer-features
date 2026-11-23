#!/bin/bash

set -e

source dev-container-features-test-lib

check "check git installed" bash -c "git --version"
check "check git flow installed" bash -c "git flow version"

reportResults
