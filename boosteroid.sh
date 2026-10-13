#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------
# Boosteroid portable installer – Arch-only
# -----------------------------------------
# Downloads the official Boosteroid portable Linux client and extracts it,
# installing only the runtime dependencies it needs from the official repos.
# It does not redistribute Boosteroid's software.

PACMAN_PACKAGES=(
  tar wget                               # fetch + extract
  libva libvdpau                         # video acceleration
  libxcb xcb-util-wm xcb-util-image      # XCB / windowing
  xcb-util-keysyms xcb-util-renderutil   # XCB / windowing
  libxinerama xorg-xinput                # X11 compatibility
  numactl                                # NUMA / CPU affinity
  traceroute                             # network diagnostics
  pcre2                                  # runtime regex library
)

INSTALL_URL="https://boosteroid.com/linux/installer/boosteroid_portable.tar"
APP_DIR="BoosteroidGamesS.R.L."

die() { echo "ERROR: $*" >&2; exit 1; }
have_cmd() { command -v "$1" >/dev/null 2>&1; }

get_priv() {
  if have_cmd sudo; then echo "sudo"
  elif have_cmd pkexec; then echo "pkexec"
  else die "Neither sudo nor pkexec found for privilege escalation."
  fi
}

detect_arch_only() {
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    local id="${ID:-}" like="${ID_LIKE:-}"
    id="${id,,}"; like="${like,,}"
    [[ "$id" =~ (arch|artix|manjaro|endeavouros) || "$like" =~ arch ]] && return 0
  fi
  have_cmd pacman && return 0
  return 1
}

echo "==> Verifying Arch-based system..."
detect_arch_only || die "This installer is Arch-only. Detected a non-Arch system."
have_cmd pacman  || die "pacman not found. This script requires pacman."

PRIV="$(get_priv)"

echo "==> Installing runtime dependencies (already-present ones are skipped):"
printf '    %s\n' "${PACMAN_PACKAGES[*]}"
# -S --needed, never -Sy: refreshing the db without a full upgrade (-Sy <pkg>)
# is a partial upgrade and can break the system. Run 'sudo pacman -Syu' yourself
# first if your package database is stale.
$PRIV pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
TARBALL="${TMPDIR}/boosteroid_portable.tar"

echo "==> Downloading the official Boosteroid portable client..."
wget -O "$TARBALL" "$INSTALL_URL"

# Optional integrity check. The vendor tarball is unversioned, so any pinned
# hash will drift whenever Boosteroid update the client:
#   echo "<SHA256>  ${TARBALL}" | sha256sum -c -

echo "==> Extracting into ./${APP_DIR}"
mkdir -p "$APP_DIR"
tar xf "$TARBALL" -C "$APP_DIR"

echo "==> Done. Launch it with:  cd '${APP_DIR}' && ./boosteroid"
