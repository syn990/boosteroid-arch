# Boosteroid Portable Installer (Arch Linux)

An Arch-only installer for the official **Boosteroid portable Linux client**. It
installs the correct runtime dependencies from the official repos and extracts
the vendor's portable tarball — nothing else. It does **not** redistribute
Boosteroid's software; the client is downloaded straight from Boosteroid.

Verified working (2026-10): the vendor payload at
`https://boosteroid.com/linux/installer/boosteroid_portable.tar` is live (~122 MB),
and every dependency below resolves in the current `core`/`extra` repos.

## Install

```bash
wget https://raw.githubusercontent.com/syn990/boosteroid-arch/main/boosteroid.sh
chmod +x boosteroid.sh
./boosteroid.sh
```

What it does:

1. Checks you're on an Arch-based system (`arch`/`artix`/`manjaro`/`endeavouros`, or any `pacman`).
2. Installs the runtime dependencies with `pacman -S --needed` (ones you already have are skipped).
3. Downloads the official portable client into a temporary directory.
4. Extracts it into `./BoosteroidGamesS.R.L.` in the current directory.
5. Cleans up the temporary files.

> Update first if your system is stale: run `sudo pacman -Syu`. The installer
> deliberately uses `-S` (not `-Sy`) so it can never trigger a partial upgrade.

## Run

```bash
cd BoosteroidGamesS.R.L.
./boosteroid
```

Add your own `.desktop` entry or wrapper script if you want it in your launcher.

## Dependencies

Installed automatically, all from the official `core`/`extra` repos:

| Purpose | Packages |
| --- | --- |
| Fetch & extract | `tar`, `wget` |
| Video acceleration | `libva`, `libvdpau` |
| XCB / windowing | `libxcb`, `xcb-util-wm`, `xcb-util-image`, `xcb-util-keysyms`, `xcb-util-renderutil` |
| X11 compatibility | `libxinerama`, `xorg-xinput` |
| NUMA / CPU affinity | `numactl` |
| Network diagnostics | `traceroute` |
| Runtime regex | `pcre2` |

## Why this exists

Boosteroid ship a portable Linux client but leave dependency installation to you,
and their per-distro notes don't map cleanly to Arch. This maps every runtime
dependency to its exact Arch package so the client just runs — no AUR helper, no
system pollution, no background services.

## Packaging / AUR

Not on the AUR (yet). The dependency table above is exactly what a PKGBUILD's
`depends=()` would carry, so this is ready to become one. Take it and package it
if you like.

## Files

```
boosteroid.sh   # the installer (Arch-only)
LICENSE         # MIT, covers this script only
```

## License

MIT — this script only. Boosteroid's own software, trademarks and binaries are
not covered: they're downloaded from Boosteroid and remain subject to their terms.
