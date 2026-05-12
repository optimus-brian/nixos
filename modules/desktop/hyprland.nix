{ config, pkgs, lib, inputs, ... }:

{
  # Hyprland — withUWSM macht's selbst (legt hyprland-uwsm.desktop in wayland-sessions an)
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.uwsm.enable = true;

  # Login-Manager: tuigreet (TUI, schlank). UWSM startet Hyprland-Session → keine Warnung.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # nixpkgs-Bug #476375: ohne -D/-e setzt uwsm XDG_CURRENT_DESKTOP=start-hyprland
        # → Warning bei jedem Login. Korrekter Syntax (uwsm 0.24+):
        #   -D Hyprland  → XDG_CURRENT_DESKTOP=Hyprland
        #   -e           → exclusive, andere Quellen verwerfen
        # Dry-Run-getestet auf Surface 2026-05-12.
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd 'uwsm start -D Hyprland -e hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  # Hyprland-Ökosystem
  environment.systemPackages = with pkgs; [
    waybar
    rofi
    fuzzel
    mako
    swww
    hyprpaper
    hyprlock
    hypridle
    hyprshot
    hyprcursor
    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    playerctl
    pamixer
    networkmanagerapplet
    pavucontrol
    polkit_gnome
    blueberry
    libnotify
  ];

  # Polkit-Agent: polkit_gnome via Hyprland exec-once (siehe home/hyprland.nix)
  # Systemd-user-Service hatte kein DISPLAY/WAYLAND_DISPLAY — exec-once aus Hyprland
  # heraus löst das, weil Hyprland die Env selbst setzt.
  security.polkit.enable = true;

  # Wayland-spezifische Env-Vars (system-wide)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
  };
}
