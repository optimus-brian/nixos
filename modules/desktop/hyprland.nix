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
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd 'uwsm start Hyprland'";
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

  # Polkit-Agent (für sudo-prompts in GUI-Apps) — GTK-basiert (polkit_gnome)
  # statt hyprpolkitagent (Qt) der ohne Qt-Wayland-Plugin crashed
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Wayland-spezifische Env-Vars (system-wide)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
  };
}
