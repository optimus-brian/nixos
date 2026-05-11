{ ... }:

{
  # Spiegelt die System-Werte für home-manager.
  # Aktiviert ALLE programs.X.catppuccin gleichzeitig hier zentral.
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # Per-Program-Aktivierung — wenn was zickt, hier auskommentieren
  programs.waybar.catppuccin.enable = true;
  programs.fuzzel.catppuccin.enable = true;
  programs.wezterm.catppuccin.enable = true;
  programs.zellij.catppuccin.enable = true;
  programs.bat.catppuccin.enable = true;
  programs.fzf.catppuccin.enable = true;
  programs.lazygit.catppuccin.enable = true;
  programs.git.delta.catppuccin.enable = true;
  programs.starship.catppuccin.enable = true;
  programs.neovim.catppuccin.enable = true;
  services.mako.catppuccin.enable = true;
  programs.hyprlock.catppuccin.enable = true;
  wayland.windowManager.hyprland.catppuccin.enable = true;
  gtk.catppuccin.enable = true;
  qt.style.catppuccin.enable = true;
}
