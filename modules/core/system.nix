{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core
    git
    wget
    curl
    vim
    htop
    btop
    tree
    file
    unzip
    p7zip
    rsync
    pciutils
    usbutils
    lm_sensors
    nvme-cli

    # Nix-Tools
    nix-output-monitor
    nh
    nix-tree

    # Surface-Diagnose
    powertop
  ];

  # Polkit für GUI-Auth-Prompts
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # GNOME Keyring (für Login-Pässe, Browser-Cookies)
  # → PAM-Hookup: Login-Passwort entsperrt Keyring automatisch
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Flatpak optional (für proprietäre Stuff falls mal nötig)
  services.flatpak.enable = true;

  # Docker (du brauchst das vermutlich für deine Apps)
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # XDG-Portale für Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
