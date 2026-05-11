{ pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/brian/.config/wallpapers/default.png" ];
      wallpaper = [ ", /home/brian/.config/wallpapers/default.png" ];
      ipc = "on";
      splash = false;
    };
  };

  # Verzeichnis für Wallpaper anlegen — Brian legt eigene rein
  xdg.configFile."wallpapers/.keep".text = "";
}
