{ ... }:

{
  # Globales catppuccin.enable triggert problematische Module (z.B. vscode → antigravity)
  # Nur Default-Werte für Flavor/Accent setzen, einzelne Programme aktivieren
  catppuccin = {
    flavor = "mocha";
    accent = "mauve";
  };

  # Programme mit catppuccin/nix-Support (offiziell)
  programs.bat.catppuccin.enable = true;
  programs.fzf.catppuccin.enable = true;
  programs.git.delta.catppuccin.enable = true;
  programs.lazygit.catppuccin.enable = true;
  programs.starship.catppuccin.enable = true;
  programs.zellij.catppuccin.enable = true;
  programs.waybar.catppuccin.enable = true;       # liefert @-Variablen für CSS
  programs.fuzzel.catppuccin.enable = true;
  programs.wezterm.catppuccin.enable = true;
  services.mako.catppuccin.enable = true;
  programs.hyprlock.catppuccin.enable = true;

  # Diese existieren ggf. nicht — nach Test re-aktivieren:
  # programs.neovim.catppuccin.enable = true;
  # wayland.windowManager.hyprland.catppuccin.enable = true;
  # gtk.catppuccin.enable = true;
  # qt.style.catppuccin.enable = true;
}
