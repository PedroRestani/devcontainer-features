#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive

CURL_WAS_INSTALLED=false
if ! command -v curl &> /dev/null; then
	echo "Installing temporary curl..."
	apt-get update
	apt-get install -y --no-install-recommends curl
	CURL_WAS_INSTALLED=true
fi

/usr/bin/curl -L https://firebase.tools | bash -s -- -x

if [ "$CURL_WAS_INSTALLED" = true ]; then
	echo "Removing temporary curl..."
	apt-get purge -y --auto-remove curl
	rm -rf /var/lib/apt/lists/*
fi
