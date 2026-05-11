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
  programs.wezterm.catppuccin.enable = true;
  services.mako.catppuccin.enable = true;
  programs.hyprlock.catppuccin.enable = true;
}
