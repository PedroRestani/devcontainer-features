#!/bin/bash
set -e


if ! command -v curl &> /dev/null; then
	apt-get update
	apt-get install -y --no-install-recommends curl
	curl -sL https://firebase.tools | bash
	apt-get purge -y --auto-remove curl
	rm -rf /var/lib/apt/lists/*
else
	curl -sSL https://firebase.tools | bash
fi
