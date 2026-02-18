#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------
# Boosteroid portable installer – Arch-only
# -----------------------------------------

PACMAN_PACKAGES="tar wget libva libvdpau libxcb xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil libxinerama xorg-xinput traceroute pcre2"

INSTALL_URL="https://boosteroid.com/linux/installer/boosteroid_portable.tar"
APP_DIR="BoosteroidGamesS.R.L."

die() { echo "ERROR: $*" >&2; exit 1; }
have_cmd() { command -v "$1" >/dev/null 2>&1; }

get_priv() {
  if have_cmd sudo; then
    echo "sudo"
  elif have_cmd pkexec; then
    echo "pkexec"
  else
    die "Neither sudo nor pkexec found for privilege escalation."
  fi
}

detect_arch_only() {
  local id like
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    id="${ID:-}"; like="${ID_LIKE:-}"
    id="${id,,}"; like="${like,,}"
    if [[ "$id" =~ (arch|artix|manjaro|endeavouros) ]] || [[ "$like" =~ arch ]]; then
      return 0
    fi
  fi
  # Fallback: pacman presence strongly implies Arch family
  if have_cmd pacman; then
    return 0
  fi
  return 1
}

echo "==> Verifying Arch-based system..."
if ! detect_arch_only; then
  die "This installer is Arch-only. Detected non-Arch system."
fi

if ! have_cmd pacman; then
  die "pacman not found. This script requires pacman."
fi

PRIV="$(get_priv)"

echo "==> Installing required packages via pacman:"
echo "    $PACMAN_PACKAGES"
$PRIV pacman -Sy --noconfirm $PACMAN_PACKAGES

# Prepare workspace
TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

TARBALL="${TMPDIR}/boosteroid_portable.tar"

echo "==> Downloading Boosteroid portable payload..."
wget -O "$TARBALL" "$INSTALL_URL"

# Optional checksum verification:
# echo "<SHA256_CHECKSUM>  ${TARBALL}" | sha256sum -c -

echo "==> Creating application directory: ${APP_DIR}"
mkdir -p "${APP_DIR}"

echo "==> Extracting payload into ${APP_DIR}"
tar xf "$TARBALL" -C "${APP_DIR}"

echo "==> Done. Launch binaries from: ${APP_DIR}"
exit 0

