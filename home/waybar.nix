{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 4;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "bluetooth"
        "battery"
        "backlight"
        "cpu"
        "memory"
      ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "10";
          urgent = "!";
          active = "";
          default = "";
        };
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 60;
      };

      clock = {
        format = "{:%H:%M  %a %d.%m.}";
        format-alt = "{:%Y-%m-%d %H:%M:%S}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      battery = {
        states = { warning = 30; critical = 15; };
        format = "Bat {capacity}%";
        format-charging = "Bat ⚡{capacity}%";
        format-plugged = "Bat ⏚{capacity}%";
        format-full = "Bat ✓{capacity}%";
      };

      network = {
        format-wifi = "WiFi {essid} {signalStrength}%";
        format-ethernet = "LAN {ipaddr}";
        format-disconnected = "⚠ Offline";
        tooltip-format = "{essid} ({signalStrength}%) — {ipaddr}";
        on-click = "iwgtk";                                     # GUI WiFi-Picker
        on-click-right = "nm-connection-editor";                 # Vollständiger Editor
      };

      pulseaudio = {
        format = "Vol {volume}%";
        format-muted = "Vol Stumm";
        on-click = "pavucontrol";
      };

      bluetooth = {
        format = "BT {status}";
        format-disabled = "";
        format-connected = "BT {device_alias}";
        on-click = "blueberry";
      };

      backlight = {
        format = "☀ {percent}%";
        on-scroll-up = "brightnessctl set +5%";
        on-scroll-down = "brightnessctl set 5%-";
      };

      cpu = { format = "CPU {usage}%"; };
      memory = { format = "RAM {percentage}%"; };

      tray = { spacing = 8; };
    };

    # catppuccin-Modul lädt @import "mocha.css" automatisch → @base, @text, @mauve etc.
    style = ''
      @define-color accent @mauve;

      * {
        font-family: "JetBrainsMono Nerd Font", "Inter", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: alpha(@base, 0.85);
        color: @text;
        border-bottom: 2px solid alpha(@accent, 0.4);
      }

      #workspaces button {
        padding: 0 8px;
        color: @overlay0;
        background: transparent;
        border-radius: 6px;
        margin: 4px 2px;
      }

      #workspaces button.active {
        color: @accent;
        background: alpha(@accent, 0.15);
      }

      #workspaces button:hover {
        background: alpha(@text, 0.1);
      }

      #window  { padding: 0 12px; color: @subtext0; }
      #clock   { padding: 0 12px; color: @yellow; font-weight: bold; }

      #battery, #network, #pulseaudio, #bluetooth,
      #backlight, #cpu, #memory, #tray {
        padding: 0 10px;
        margin: 4px 2px;
        border-radius: 6px;
        background: alpha(@surface0, 0.5);
      }

      #battery.warning  { color: @yellow; }
      #battery.critical { color: @red; animation: blink 1s infinite alternate; }

      @keyframes blink { to { background: @red; color: @base; } }
    '';
  };
}
