{ pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/.config/wallpapers/default.jpg" ];
      wallpaper = [ ", ~/.config/wallpapers/default.jpg" ];
      ipc = "on";
      splash = false;
    };
  };

  # Verzeichnis für Wallpaper anlegen — Brian legt eigene rein
  xdg.configFile."wallpapers/.keep".text = "";
}
