{ ... }:

{
  catppuccin = {
    flavor = "mocha";
    accent = "mauve";
  };

  # Programme einzeln aktivieren (globales catppuccin.enable triggert vscode-Bug)
  programs.bat.catppuccin.enable = true;
  programs.fzf.catppuccin.enable = true;
  programs.git.delta.catppuccin.enable = true;
  programs.lazygit.catppuccin.enable = true;
  programs.starship.catppuccin.enable = true;
  programs.zellij.catppuccin.enable = true;
  programs.waybar.catppuccin.enable = true;
  programs.fuzzel.catppuccin.enable = true;
  # programs.wezterm.catppuccin — gibt's in release-25.11 nicht, color_scheme bleibt hardcoded
  services.mako.catppuccin.enable = true;
  # programs.hyprlock.catppuccin.enable = true;
  # → kollidiert mit unserer hyprlock-Config (definiert zusätzliches input-field + label)
  # → wir nutzen Brand-Farben in unserer Config direkt
}
