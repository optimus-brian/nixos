{ config, pkgs, inputs, ... }:

{
  # Hyprland (system-side enable)
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # Login-Manager: greetd + tuigreet (passt zum TUI-Flow, kein KDE/GDM-Bloat)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd Hyprland";
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
    blueberry
    libnotify
  ];

  # Polkit-Agent (für sudo-prompts in GUI-Apps) — offizielles NixOS-Modul
  security.polkit.enable = true;
  programs.hyprpolkitagent.enable = true;

  # Wayland-spezifische Env-Vars (system-wide)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
  };
}
