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

    # "Floating Islands" style — Bar selbst transparent, Module als Pills
    style = ''
      @define-color accent @mauve;

      * {
        font-family: "JetBrainsMono Nerd Font", "Inter", sans-serif;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: transparent;       /* Bar selbst durchsichtig */
        color: @text;
      }

      /* Jedes Modul wird zu einem Pill mit eigenem Hintergrund + Rundung */
      #workspaces,
      #window,
      #clock,
      #tray,
      #pulseaudio,
      #network,
      #bluetooth,
      #battery,
      #backlight,
      #cpu,
      #memory {
        background: alpha(@base, 0.75);
        border-radius: 12px;
        margin: 6px 4px;
        padding: 0 12px;
        border: 1px solid alpha(@accent, 0.15);
      }

      /* Workspaces: Buttons in einem Pill-Container */
      #workspaces { padding: 0 4px; }

      #workspaces button {
        padding: 0 8px;
        color: @overlay0;
        background: transparent;
        border-radius: 8px;
        border: none;
        margin: 3px 2px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: @base;
        background: @accent;
      }

      #workspaces button:hover {
        background: alpha(@accent, 0.2);
        color: @accent;
      }

      #clock   { color: @yellow; font-weight: bold; }
      #window  { color: @subtext0; font-style: italic; }

      #pulseaudio { color: @green; }
      #network    { color: @blue; }
      #bluetooth  { color: @sapphire; }
      #battery    { color: @teal; }
      #backlight  { color: @yellow; }
      #cpu        { color: @peach; }
      #memory     { color: @mauve; }

      #battery.warning  { color: @yellow; }
      #battery.critical { color: @red; animation: blink 1s infinite alternate; }

      @keyframes blink {
        to { background: @red; color: @base; }
      }
    '';
  };
}
