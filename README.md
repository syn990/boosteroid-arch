
# Boosteroid Portable Installer (Arch Linux)

A lightweight, secure, and Arch‑optimised installer for the **Boosteroid Portable Linux Client**.  
This script automates dependency installation and clean extraction of the official Boosteroid portable tarball using only **pacman** and standard system tools.

---

## 🔧 Overview

This project provides:

- An **Arch‑only** installer (`pacman` required)  
- Safe, temporary workspace for downloaded files  
- Automatic dependency installation  
- Clean extraction into a dedicated application directory  
- Optional checksum verification  
- No AUR helpers, no system pollution, no background services  

The script does **not** redistribute Boosteroid software.  
It only downloads the official portable client directly from Boosteroid’s servers.

---

## 📦 Dependencies

The installer handles all required packages automatically.  
Here’s the full dependency map for reference:

| Purpose                        | Package(s)                                                                           |
| ------------------------------ | ------------------------------------------------------------------------------------ |
| Core Tools                     | `tar`, `wget`                                                                        |
| Video Acceleration             | `libva`, `libvdpau`                                                                  |
| XCB / Windowing Components     | `libxcb`, `xcb-util-wm`, `xcb-util-image`, `xcb-util-keysyms`, `xcb-util-renderutil` |
| X11 Compatibility              | `libxinerama`, `xorg-xinput`                                                         |
| NUMA Management / CPU Affinity | `numactl`                                                                            |
| Network Utilities              | `traceroute`                                                                         |
| Runtime Library Support        | `pcre2`                                                                              |

---

## 🚀 Installation

### 1. Download the installer

```bash
wget https://raw.githubusercontent.com/syn990/boosteroid-arch/BoosteroidInstall.sh
chmod +x BoosteroidInstall.sh
````

### 2. Run it

```bash
./BoosteroidInstall.sh
```

The script will:

1.  Verify that you're running an Arch‑based system
2.  Install required dependencies
3.  Download the Boosteroid portable package
4.  Extract it safely into:

<!---->

    BoosteroidGamesS.R.L/

5.  Clean up temporary files

***

## ▶️ Running Boosteroid

Inside the extracted directory, launch the Boosteroid binary:

```bash
cd BoosteroidGamesS.R.L
./boosteroid
```

You may optionally create your own `.desktop` launcher or wrapper script.

***

## 📁 Project Structure

    /
    ├── Boosteroid.sh          # Main installer (Arch-only)
    └── LICENSE                    # MIT License covering this script

*Boosteroid’s binaries will appear after running the installer.*

***

## 🔍 Security Notes

*   The script uses `mktemp -d` for workspace isolation
*   Privilege escalation is routed through `sudo` (or `pkexec` fallback)
*   Optional SHA256 verification block is included inside the script
*   No permanent system modifications except dependency installation

***

## 🧩 Why This Exists

Boosteroid provides a portable Linux client, but dependency installation varies by distribution.  
This script makes **Arch Linux** a first‑class citizen by providing:

*   Correctly mapped dependencies
*   Clean extraction
*   No-frills execution path

It follows a similar philosophy used in SYN‑OS development: keep things simple, explicit, and user‑controlled.

***

## 📜 License

This installer script is licensed under the **MIT License**.  
See `LICENSE.md` for full details.

> **Important:**  
> Boosteroid’s own software, trademarks, and binaries are NOT licensed under MIT.  
> They are downloaded directly from Boosteroid and remain subject to their terms.

***

## 📝 Contributing

Don't bother.
Take it and put it on the AUR.

***

## ✔️ Summary

This project provides a:

*   Clean
*   Simple
*   Arch‑focused
*   Secure

installer for the Boosteroid Portable Client without modifying or redistributing Boosteroid’s software.
