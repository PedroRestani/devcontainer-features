#!/bin/sh
# This code is mostly generated from Gemini AI Auto from web chat, very little change was made.
# T'was read through but I didn't go through every implementation detail
# Help make it better if possible plz

set -eu

REPO="gittower/git-flow-next"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d)"

ADDED_PKGS=""
CLEANUP_DONE=0

VERSION="${VERSION:-latest}"
VERSION_TO_INSTALL="$(printf '%s' "$VERSION" | tr -d '[:space:]')"
if [ -z "$VERSION_TO_INSTALL" ]; then
  echo "Invalid version: $VERSION" >&2
  exit 1
fi

if [ "$VERSION_TO_INSTALL" != "latest" ]; then
  if ! printf '%s\n' "$VERSION_TO_INSTALL" | grep -qE '^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$'; then
    echo "Invalid version: $VERSION_TO_INSTALL" >&2
    exit 1
  fi
  RELEASE="v${VERSION_TO_INSTALL#v}"
else
  RELEASE="latest"
fi

has_pkg() {
  target="$1"
  case " ${ADDED_PKGS} " in
    *" ${target} "*) return 0 ;;
    *) return 1 ;;
  esac
}

register_installed_pkg() {
  for pkg in "$@"; do
    case "$pkg" in
      git|git-flow) continue ;;
    esac
    if ! has_pkg "$pkg"; then
      if [ -z "$ADDED_PKGS" ]; then
        ADDED_PKGS="$pkg"
      else
        ADDED_PKGS="${ADDED_PKGS} ${pkg}"
      fi
    fi
  done
}

run_pkg_remove() {
  # shellcheck disable=SC2086
  case "$PKG_MANAGER" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      apt-get remove -y -qq $ADDED_PKGS >/dev/null 2>&1 || true
      apt-get autoremove -y -qq >/dev/null 2>&1 || true
      rm -rf /var/lib/apt/lists/*
      ;;
    apk)
      apk del --no-cache $ADDED_PKGS >/dev/null 2>&1 || true
      ;;
    dnf)
      dnf remove -y -q $ADDED_PKGS >/dev/null 2>&1 || true
      ;;
    microdnf)
      microdnf remove -y $ADDED_PKGS >/dev/null 2>&1 || true
      ;;
    yum)
      yum remove -y -q $ADDED_PKGS >/dev/null 2>&1 || true
      ;;
    pacman)
      pacman -Rns --noconfirm $ADDED_PKGS >/dev/null 2>&1 || true
      ;;
    zypper)
      zypper --non-interactive remove $ADDED_PKGS >/dev/null 2>&1 || true
      ;;
    brew)
      brew uninstall --ignore-dependencies $ADDED_PKGS >/dev/null 2>&1 || true
      ;;
  esac
}

remove_temp_packages() {
  if [ -z "$ADDED_PKGS" ] || [ -z "${PKG_MANAGER:-}" ]; then
    return 0
  fi

  echo "Cleaning up temporary installation dependencies: ${ADDED_PKGS}..."
  run_pkg_remove
}

cleanup() {
  if [ "$CLEANUP_DONE" -eq 1 ]; then
    return 0
  fi
  CLEANUP_DONE=1
  [ -n "${TMP_DIR:-}" ] && rm -rf "$TMP_DIR"
  remove_temp_packages
}
trap cleanup EXIT

# 1. Gets system info (OS, distro, arquitetura, gerenciador de pacotes)
detect_system_info() {
  OS_KERNEL="$(uname -s | tr '[:upper:]' '[:lower:]')"
  MACHINE="$(uname -m)"

  case "$MACHINE" in
    x86_64|amd64)
      ARCH="amd64"
      ;;
    aarch64|arm64)
      ARCH="arm64"
      ;;
    *)
      echo "Error: unsupported architecture: ${MACHINE}" >&2
      exit 1
      ;;
  esac

  DISTRO_ID="unknown"
  DISTRO_LIKE=""
  DISTRO_NAME="$OS_KERNEL"

  if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO_ID="${ID:-unknown}"
    DISTRO_LIKE="${ID_LIKE:-}"
    DISTRO_NAME="${PRETTY_NAME:-${NAME:-$OS_KERNEL}}"
  fi

  PKG_MANAGER=""
  if [ "$OS_KERNEL" = "linux" ]; then
    if command -v apt-get >/dev/null 2>&1; then
      PKG_MANAGER="apt"
    elif command -v apk >/dev/null 2>&1; then
      PKG_MANAGER="apk"
    elif command -v dnf >/dev/null 2>&1; then
      PKG_MANAGER="dnf"
    elif command -v microdnf >/dev/null 2>&1; then
      PKG_MANAGER="microdnf"
    elif command -v yum >/dev/null 2>&1; then
      PKG_MANAGER="yum"
    elif command -v pacman >/dev/null 2>&1; then
      PKG_MANAGER="pacman"
    elif command -v zypper >/dev/null 2>&1; then
      PKG_MANAGER="zypper"
    fi
  elif [ "$OS_KERNEL" = "darwin" ] && command -v brew >/dev/null 2>&1; then
    PKG_MANAGER="brew"
  fi

  echo "System info: ${DISTRO_NAME} (kernel=${OS_KERNEL}, id=${DISTRO_ID}, arch=${ARCH}, pkg=${PKG_MANAGER:-none})"
}

# 2. Install dependencies (curl, ca-certificates, tar) temporarily
ensure_base_tools() {
  missing=""
  command -v curl >/dev/null 2>&1 || missing="${missing} curl"
  command -v tar  >/dev/null 2>&1 || missing="${missing} tar"

  if [ -z "$missing" ]; then
    return 0
  fi

  to_install="${missing} ca-certificates"
  # Remove espacos extras no inicio
  to_install="$(printf '%s' "$to_install" | awk '{$1=$1; print}')"

  echo "Installing temporary tools (${to_install})..."
  # shellcheck disable=SC2086
  case "$PKG_MANAGER" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -qq
      apt-get install -y -qq --no-install-recommends $to_install
      rm -rf /var/lib/apt/lists/*
      ;;
    apk)
      apk add --no-cache $to_install
      ;;
    dnf)
      dnf install -y -q $to_install
      ;;
    microdnf)
      microdnf install -y $to_install
      ;;
    yum)
      yum install -y -q $to_install
      ;;
    pacman)
      pacman -Sy --noconfirm $to_install
      ;;
    zypper)
      zypper --non-interactive install $to_install
      ;;
    brew)
      # shellcheck disable=SC2086
      brew install $missing
      ;;
    *)
      echo "Error: Unable to install ${to_install} automatically (unsupported package manager)." >&2
      exit 1
      ;;
  esac

  # shellcheck disable=SC2086
  register_installed_pkg $to_install
}

# 3. Checks for git; if not installed, installs based on system info
install_git_if_needed() {
  if command -v git >/dev/null 2>&1; then
    echo "Found git: $(git --version)"
    return 0
  fi

  echo "Git not found. Starting ${DISTRO_NAME} install..."
  case "$PKG_MANAGER" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -qq
      apt-get install -y -qq --no-install-recommends git
      rm -rf /var/lib/apt/lists/*
      ;;
    apk)
      apk add --no-cache git
      ;;
    dnf)
      dnf install -y -q git
      ;;
    microdnf)
      microdnf install -y git
      ;;
    yum)
      yum install -y -q git
      ;;
    pacman)
      pacman -Sy --noconfirm git
      ;;
    zypper)
      zypper --non-interactive install git
      ;;
    brew)
      brew install git
      ;;
    *)
      echo "Error: Unable to install git automatically." >&2
      exit 1
      ;;
  esac

  echo "Installed git successfully: $(git --version)"
}

# 4. Downloads and installs chosen git-flow-next release from GitHub
install_git_flow_next() {
  if [ "$RELEASE" = "latest" ]; then
    api_url="https://api.github.com/repos/${REPO}/releases/latest"
  else
    api_url="https://api.github.com/repos/${REPO}/releases/tags/${RELEASE}"
  fi

  echo "Getting ${RELEASE} release from ${REPO} for ${OS_KERNEL}-${ARCH}..."
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    release_json="$(curl -fsSL -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" "$api_url")"
  else
    release_json="$(curl -fsSL -H "Accept: application/vnd.github+json" "$api_url")"
  fi

  download_url="$(
    printf '%s\n' "$release_json" \
      | grep -oE '"browser_download_url"[[:space:]]*:[[:space:]]*"[^"]+"' \
      | sed -E 's/.*"([^"]+)"/\1/' \
      | grep -E "${OS_KERNEL}-${ARCH}\.tar\.gz$" \
      | head -n 1
  )"

  if [ -z "$download_url" ]; then
    echo "Error: asset ${OS_KERNEL}-${ARCH}.tar.gz not found in ${REPO} (${RELEASE})." >&2
    exit 1
  fi

  archive_path="${TMP_DIR}/git-flow-next.tar.gz"
  echo "Downloading ${download_url}..."
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    curl -fsSL -H "Authorization: Bearer ${GITHUB_TOKEN}" "$download_url" -o "$archive_path"
  else
    curl -fsSL "$download_url" -o "$archive_path"
  fi

  tar -xzf "$archive_path" -C "$TMP_DIR"

  bin_path="$(
    find "$TMP_DIR" -type f -name "git-flow*" ! -name "*.tar.gz" ! -name "*.tgz" \
      | LC_ALL=C sort \
      | head -n 1
  )"
  if [ -z "$bin_path" ]; then
    echo "Error: binary with prefix 'git-flow' not found." >&2
    exit 1
  fi

  install -d "$INSTALL_DIR"
  install -m 0755 "$bin_path" "${INSTALL_DIR}/git-flow"

  echo "git-flow-next installed at ${INSTALL_DIR}/git-flow"
  git flow version || true
}

main() {
  detect_system_info
  ensure_base_tools
  install_git_if_needed
  install_git_flow_next
}

main "$@"
