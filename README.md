# NixOS Surface Laptop 5 — Brian's Hyprland Setup

Flake-basierte NixOS-Konfiguration für den Microsoft Surface Laptop 5 (Gen 5, 2022).

## Stack

- **NixOS:** 25.11
- **WM:** Hyprland (Wayland) + Waybar + Hyprlock + Hypridle
- **Terminal:** WezTerm (mit Catppuccin Mocha + JetBrainsMono Nerd Font)
- **Sidebar-Tabs:** Zellij (`ALT+Z` aus WezTerm) — echte vertikale Tab-Liste
- **Mail:** neomutt (TUI mit linker Sidebar) + himalaya (CLI) + isync/msmtp
- **Notes:** Obsidian
- **Login:** greetd + tuigreet (TUI)
- **Shell:** Zsh + Starship + Atuin + Zoxide + FZF
- **Editor:** Neovim (default) + Cursor + VSCode

## Surface-Hardware

- linux-surface Kernel via `nixos-surface` flake
- IPTSD (Touch + Pen)
- TLP + Thermald für Akku/Wärme
- iio-sensor-proxy für Auto-Rotate
- fwupd für Firmware-Updates

## Installation

### 1. Minimal-ISO booten

```bash
# Auf Mac:
curl -LO https://channels.nixos.org/nixos-25.11/latest-nixos-minimal-x86_64-linux.iso

# Auf USB schreiben (Vorsicht — diskN richtig wählen!):
diskutil list
diskutil unmountDisk /dev/diskN
sudo dd if=latest-nixos-minimal-x86_64-linux.iso of=/dev/rdiskN bs=4m status=progress
```

### 2. Auf Surface booten + WiFi

Im Live-System:

```bash
sudo systemctl start NetworkManager
nmtui              # WiFi auswählen, Passwort eingeben
ping 1.1.1.1
```

### 3. Disk partitionieren (Beispiel: ganze Disk, ext4 + EFI)

```bash
sudo -i
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 1GB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 1GB 100%

mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
```

### 4. Config klonen + hardware-config generieren

```bash
nix-shell -p git --run "git clone https://github.com/optimus-brian/nixos.git /mnt/etc/nixos"
cd /mnt/etc/nixos

# Hardware-Config generieren — nur Hardware-Teile, kein Filesystems-Block
nixos-generate-config --root /mnt --no-filesystems
# Resultat liegt unter /mnt/etc/nixos/hardware-configuration.nix
# Kopiere den Output nach hosts/surface/hardware-configuration.nix:
cp /mnt/etc/nixos/hardware-configuration.nix hosts/surface/hardware-configuration.nix
```

### 5. Installieren

```bash
nixos-install --flake .#surface --no-root-passwd
# Setzt initialPassword = "changeme" für brian
reboot
```

### 6. Erster Login

- User: `brian`
- Passwort: `changeme` → sofort ändern: `passwd`
- Hyprland startet via tuigreet
- WiFi via Waybar-Network-Tray oder `nmtui`

## Tägliche Workflows

```bash
# Nach Config-Änderung:
nrs            # rebuild + switch (alias)
nrt            # rebuild test (kein switch)
nfu            # flake update

# Mail:
neomutt        # full TUI
himalaya       # quick CLI

# Editor:
nvim           # default
cursor         # für AI-Editing

# Workspaces:
SUPER+1..0     # workspace wechseln
SUPER+SHIFT+N  # window auf workspace N
SUPER+RETURN   # WezTerm
SUPER+B        # Browser
SUPER+O        # Obsidian
SUPER+M        # neomutt
SUPER+L        # lock
SUPER+R        # fuzzel launcher
```

## Was noch fehlt (machen wir auf dem Surface)

- [ ] Mail-Account konfigurieren (himalaya account add + neomutt mailbox)
- [ ] iCloud-Vault syncen (Syncthing oder rclone gegen iCloud)
- [ ] WireGuard-Profil ins NetworkManager importieren (Homelab-VPN)
- [ ] OneDev-SSH-Key generieren + hochladen
- [ ] Pen-Kalibrierung testen
- [ ] Wallpaper setzen (`swww img <path>`)
- [ ] obsidian-cli (offizielle CLI von vault) — gibt's nicht in nixpkgs, kommt via npm-overlay

## Struktur

```
.
├── flake.nix                     # Inputs + outputs
├── hosts/surface/
│   ├── default.nix               # System-Hauptconfig
│   ├── surface.nix               # Surface-spezifische Hardware
│   └── hardware-configuration.nix # vom Installer überschrieben
├── modules/
│   ├── system.nix                # Core-Pakete, Polkit, Docker
│   ├── hyprland.nix              # Hyprland system-level
│   ├── audio.nix                 # PipeWire
│   ├── fonts.nix                 # Nerd Fonts + Sans/Mono
│   └── networking.nix            # NetworkManager + Firewall
└── home/
    ├── default.nix               # Home-Manager-Root
    ├── hyprland.nix              # Hyprland-Bindings + Animationen
    ├── waybar.nix                # Top-Bar
    ├── wezterm.nix               # Terminal + Zellij
    ├── neomutt.nix               # Mail-TUI mit Sidebar
    ├── zsh.nix                   # Shell + Starship + Atuin
    ├── git.nix                   # Git + Lazygit + Delta
    └── programs.nix              # Daily Drivers
```

## Changelog

### 2026-05-08
- Initiale Config erstellt für Surface Laptop 5 + Hyprland
- WezTerm + Zellij für Sidebar-Tabs
- neomutt + himalaya als Mail-Stack (TUI)
- Catppuccin Mocha durchgängig
