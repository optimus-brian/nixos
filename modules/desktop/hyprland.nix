{ config, pkgs, lib, inputs, ... }:

{
  # Hyprland (system-side enable) — über UWSM gestartet, kein "start-hyprland" Warning
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

  # Polkit-Agent (für sudo-prompts in GUI-Apps) — custom systemd
  # (programs.hyprpolkitagent gibt's erst in NixOS 25.12+)
  security.polkit.enable = true;
  systemd.user.services.hyprpolkitagent = {
    description = "Hyprland Polkit Agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "always";
    };
  };

  # Wayland-spezifische Env-Vars (system-wide)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
  };
}
