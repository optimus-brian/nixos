{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Nerd Fonts (Icons für Waybar, WezTerm, neomutt etc.)
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.symbols-only

      # Sans / Serif
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # Mono
      jetbrains-mono
      fira-code
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
