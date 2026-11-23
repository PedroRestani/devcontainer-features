#!/bin/bash

set -e

source dev-container-features-test-lib

check "check git installed" bash -c "git --version"
check "check git flow installed" bash -c "git flow version"
check "check git flow version matches ${VERSION}" bash -c '
  set -e
  out="$(git flow version)"
  echo "$out"
  printf "%s\n" "$out" | grep -qE "(|[^0-9A-Za-z.-])v?${1}([^0-9A-Za-z.-]|)"
' _ "$VERSION"

reportResults
