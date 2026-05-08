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
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-plugged = "  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };

      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = "  {ipaddr}";
        format-disconnected = "⚠  Offline";
        tooltip-format = "{essid} ({signalStrength}%) — {ipaddr}";
        on-click = "wezterm start --class=nmtui -- nmtui";
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰝟  Stumm";
        format-icons.default = [ "" "" "" ];
        on-click = "pavucontrol";
      };

      bluetooth = {
        format = "  {status}";
        format-disabled = "";
        format-connected = "  {device_alias}";
        on-click = "blueberry";
      };

      backlight = {
        format = "  {percent}%";
        on-scroll-up = "brightnessctl set +5%";
        on-scroll-down = "brightnessctl set 5%-";
      };

      cpu = { format = "  {usage}%"; };
      memory = { format = "  {percentage}%"; };

      tray = { spacing = 8; };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Inter", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
        border-bottom: 2px solid rgba(203, 166, 247, 0.4);
      }

      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
        background: transparent;
        border-radius: 6px;
        margin: 4px 2px;
      }

      #workspaces button.active {
        color: #cba6f7;
        background: rgba(203, 166, 247, 0.15);
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      #window {
        padding: 0 12px;
        color: #a6adc8;
      }

      #clock {
        padding: 0 12px;
        color: #f9e2af;
        font-weight: bold;
      }

      #battery, #network, #pulseaudio, #bluetooth, #backlight, #cpu, #memory, #tray {
        padding: 0 10px;
        margin: 4px 2px;
        border-radius: 6px;
        background: rgba(49, 50, 68, 0.5);
      }

      #battery.warning  { color: #f9e2af; }
      #battery.critical { color: #f38ba8; animation: blink 1s infinite alternate; }

      @keyframes blink {
        to { background: #f38ba8; color: #1e1e2e; }
      }
    '';
  };
}
