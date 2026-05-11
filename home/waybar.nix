{ config, pkgs, lib, ... }:

let
  # Toggle-Script: btop in WezTerm — floating, mittig, definierte Größe
  toggleBtop = pkgs.writeShellScriptBin "toggle-btop" ''
    if ${pkgs.procps}/bin/pgrep -f 'wezterm.*btop' > /dev/null; then
      ${pkgs.procps}/bin/pkill -f 'wezterm.*btop'
    else
      ${pkgs.wezterm}/bin/wezterm start --class=btop-popup -- ${pkgs.btop}/bin/btop &
      # warten bis Fenster da ist, dann float + size + center
      sleep 0.4
      ${pkgs.hyprland}/bin/hyprctl dispatch togglefloating class:btop-popup
      ${pkgs.hyprland}/bin/hyprctl dispatch resizewindowpixel "exact 1100 750,class:btop-popup"
      ${pkgs.hyprland}/bin/hyprctl dispatch centerwindow
    fi
  '';
in
{
  home.packages = [ toggleBtop ];

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

      cpu = {
        format = "CPU {usage}%";
        on-click = "toggle-btop";
      };
      memory = {
        format = "RAM {percentage}%";
        on-click = "toggle-btop";
      };

      tray = { spacing = 8; };
    };

    # rieth.io Brand — Dark-Variante mit Brand-Tokens aus styleguide
    style = ''
      /* Brand colors */
      @define-color r-ink       #0B1B2A;
      @define-color r-ink-2     #1A2F45;
      @define-color r-ink-3     #4A5A6E;
      @define-color r-ink-4     #8795A4;
      @define-color r-rule      #D7DCE2;
      @define-color r-blue      #1F5C85;
      @define-color r-blue-tint #7FB8DC;
      @define-color r-blue-deep #164361;
      @define-color r-ok        #1F7A4D;
      @define-color r-warn      #B57B1A;
      @define-color r-danger    #B4361A;

      * {
        font-family: "JetBrains Mono", "Inter", sans-serif;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: transparent;
        color: @r-rule;
      }

      /* Jedes Modul = Pill in Brand-Ink mit Brand-Blue-Rand */
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
        background: alpha(@r-ink, 0.85);
        border: 1px solid alpha(@r-blue, 0.4);
        border-radius: 12px;
        margin: 6px 4px;
        padding: 0 12px;
        color: @r-rule;
      }

      #workspaces { padding: 0 4px; }

      #workspaces button {
        padding: 0 8px;
        color: @r-ink-4;
        background: transparent;
        border-radius: 8px;
        border: none;
        margin: 3px 2px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: @r-rule;
        background: @r-blue;
      }

      #workspaces button:hover {
        background: alpha(@r-blue-tint, 0.2);
        color: @r-blue-tint;
      }

      #clock      { color: @r-blue-tint; font-weight: bold; }
      #window     { color: @r-ink-4; font-style: italic; }

      #pulseaudio { color: @r-ok; }
      #network    { color: @r-blue-tint; }
      #bluetooth  { color: @r-blue; }
      #battery    { color: @r-ok; }
      #backlight  { color: @r-warn; }
      #cpu        { color: @r-blue-tint; }
      #memory     { color: @r-rule; }

      #battery.warning  { color: @r-warn; }
      #battery.critical {
        color: @r-rule;
        background: @r-danger;
        animation: blink 1s infinite alternate;
      }

      @keyframes blink {
        to { background: alpha(@r-danger, 0.5); }
      }
    '';
  };
}
