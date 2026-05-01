# C++ Env Setup Wizard

A fully automated, GUI-driven (via `whiptail`) setup and uninstaller script for modern C++ development environments. It automatically detects your OS and supports Debian/Ubuntu (`apt`), Fedora (`dnf`), and Arch Linux (`pacman`).

---

## Quick Run (One-Command)
If you host the script on GitHub or a private server, you can download and run it instantly with a single command:

**Installer:**
```bash
curl -sSL https://raw.githubusercontent.com/tiwut/C-Development-Environment---Install-Wizard/refs/heads/main/install.sh | bash
```
**Uninstaller:**
```bash
curl -sSL https://raw.githubusercontent.com/tiwut/C-Development-Environment---Install-Wizard/refs/heads/main/uninstall.sh | bash
```
___

## Manual Usage
### 1. Setup the Environment
Make the setup script executable and start the wizard:

```bash
chmod +x install.sh
./install.sh
```
### 2. Uninstall the Environment
The uninstaller automatically scans your system for installed tools and vcpkg libraries to remove them cleanly:
```bash
chmod +x uninstall.sh
./uninstall.sh
```
---

<img width="auto" height="auto" alt="Screenshot" src="install.png" />
<img width="auto" height="auto" alt="Screenshot" src="uninstall.png" />

---

## Features
* **Auto-Detects Package Manager:**
  
  Seamlessly works with apt, dnf, and pacman.
  
* **Interactive TUI:**
  
  User-friendly terminal GUI to select Core Tools, Libraries, and Frameworks.
  
* **Two Installation Scopes:**
  
  Choose between system-wide installation (requires sudo) or local user installation (using vcpkg in ~/.vcpkg).
  
* **Smart Uninstaller:**
  
  Only lists components that are actually installed on your machine.
