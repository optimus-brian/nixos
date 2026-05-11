{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [
    ./theme.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./waybar.nix
    ./wezterm.nix
    ./neomutt.nix
    ./zsh.nix
    ./git.nix
    ./programs.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # XDG Base Directories
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Cursor Theme
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  # GTK Theme (Catppuccin Mocha Mauve)
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
