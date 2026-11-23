#!/bin/sh
set -e

# NOTE: Firebase CLI seems to be entirely Debian-based, as installations fails on Alpine needing extra libraries to work
# Alpine support has been commented out,
# but for the repository standards it should be implemented at some point

PKG_MANAGER=""
if command -v apt-get >/dev/null 2>&1; then
	PKG_MANAGER="apt"
	export DEBIAN_FRONTEND=noninteractive
# elif command -v apk >/dev/null 2>&1; then
# 	PKG_MANAGER="apk"
else
	echo "Error: Unsupported package manager." >&2
	exit 1
fi

install_pkgs() {
	if [ "$PKG_MANAGER" = "apt" ]; then
		apt-get update
		apt-get install -y --no-install-recommends "$@"
	# elif [ "$PKG_MANAGER" = "apk" ]; then
	# 	apk add --no-cache "$@"
	fi
}

remove_pkgs() {
	if [ "$PKG_MANAGER" = "apt" ]; then
		apt-get purge -y --auto-remove "$@"
		rm -rf /var/lib/apt/lists/*
	# elif [ "$PKG_MANAGER" = "apk" ]; then
	# 	apk del "$@"
	fi
}

CURL_WAS_INSTALLED=false
BASH_WAS_INSTALLED=false

NEED_INSTALL=""
if ! command -v curl >/dev/null 2>&1; then
	NEED_INSTALL="$NEED_INSTALL curl ca-certificates"
	CURL_WAS_INSTALLED=true
fi

if ! command -v bash >/dev/null 2>&1; then
	NEED_INSTALL="$NEED_INSTALL bash"
	BASH_WAS_INSTALLED=true
fi

if [ -n "$NEED_INSTALL" ]; then
	echo "Installing temporary dependencies: $NEED_INSTALL..."
	# shellcheck disable=SC2086
	install_pkgs $NEED_INSTALL
fi

curl -sL https://firebase.tools | bash

TO_REMOVE=""
if [ "$CURL_WAS_INSTALLED" = true ]; then
	TO_REMOVE="$TO_REMOVE curl ca-certificates"
fi

if [ "$BASH_WAS_INSTALLED" = true ]; then
	TO_REMOVE="$TO_REMOVE bash"
fi

if [ -n "$TO_REMOVE" ]; then
	echo "Removing temporary dependencies: $TO_REMOVE..."
	# shellcheck disable=SC2086
	remove_pkgs $TO_REMOVE
fi
