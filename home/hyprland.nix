{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    systemd.variables = [ "--all" ];

    settings = {
      # Surface Laptop 5: 2256x1504 ÷ 1.333333 = 1692×1128 (sauber, 4/3)
      monitor = [ ", preferred, auto, 1.333333" ];

      "$mod" = "SUPER";
      "$terminal" = "wezterm";
      "$browser" = "firefox";
      "$fileManager" = "thunar";
      "$menu" = "fuzzel";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "GDK_BACKEND,wayland,x11"
      ];

      exec-once = [
        # waybar + mako + hyprpaper laufen als systemd user services
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        # rieth.io Brand: blue (#1F5C85) → blue-tint (#7FB8DC) gradient
        "col.active_border" = "rgba(1F5C85ee) rgba(7FB8DCee) 45deg";
        "col.inactive_border" = "rgba(4A5A6Eaa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.95;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        ];
        animation = [
          "windows, 1, 4, easeOutQuint"
          "windowsOut, 1, 4, easeOutQuint, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 5, easeOutQuint, slide"
        ];
      };

      input = {
        kb_layout = "de";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          drag_3fg = 1;          # Mac-Style: 3 Finger drücken+ziehen = Drag (Markieren/Verschieben)
          tap-and-drag = true;   # Tap+Halten+Ziehen geht auch
        };
      };

      # Mac-Style Trackpad-Gesten — 3-Finger reserviert für Drag-and-Drop
      gesture = [
        "4, horizontal, workspace"   # 4-Finger-Swipe horizontal = Workspace wechseln
        "4, up, fullscreen"          # 4 Finger hoch = Fullscreen toggle
      ];

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        # vfr = true;   # entfernt in 0.50+
      };

      dwindle = {
        # pseudotile entfernt — nicht mehr Top-Level option
        preserve_split = true;
      };

      bind = [
        # Apps
        "$mod, Return, exec, $terminal"
        "$mod, B, exec, $browser"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"
        "$mod, SPACE, exec, $menu"
        "$mod, O, exec, obsidian"
        "$mod SHIFT, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        # Window-Management
        "$mod, Q, killactive,"
        "$mod SHIFT, Q, exit,"
        "$mod, F, fullscreen,"
        "$mod, V, togglefloating,"
        # togglesplit/pseudo entfernt — deprecated dispatchers in 0.50+

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Screenshots
        ", Print, exec, hyprshot -m output"
        "$mod, Print, exec, hyprshot -m region"
        "$mod SHIFT, Print, exec, hyprshot -m window"

        # Lock
        "$mod, L, exec, hyprlock"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
        ",XF86AudioMute, exec, pamixer -t"
        ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];

      # Hyprland 0.55: neue Syntax mit `match:class ...` und value-Pflicht (float on statt float)
      windowrule = [
        "float on, match:class btop-popup"
        "size 1100 750, match:class btop-popup"
        "center, match:class btop-popup"

        "float on, match:class pavucontrol"
        "float on, match:class blueberry.py"
        "float on, match:class nm-connection-editor"
        "float on, match:title Picture-in-Picture"
      ];
    };
  };

  # Hypridle (idle-Manager)
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        { timeout = 300; on-timeout = "brightnessctl -s set 10"; on-resume = "brightnessctl -r"; }
        { timeout = 600; on-timeout = "loginctl lock-session"; }
        { timeout = 900; on-timeout = "hyprctl dispatch dpms off"; on-resume = "hyprctl dispatch dpms on"; }
        { timeout = 1800; on-timeout = "systemctl suspend"; }
      ];
    };
  };

  # Hyprlock (lockscreen)
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
      };
      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];
      input-field = [{
        size = "300, 50";
        position = "0, 0";
        halign = "center";
        valign = "center";
        monitor = "eDP-1";          # explizit, sonst doppelt bei fractional scale
        dots_center = true;
        fade_on_empty = true;
        outline_thickness = 2;
        # rieth.io Brand
        outer_color = "rgba(31, 92, 133, 0.8)";   # r-blue
        inner_color = "rgba(11, 27, 42, 0.8)";    # r-ink
        font_color = "rgba(215, 220, 226, 1)";    # r-rule
        placeholder_text = "<i>Passwort...</i>";
      }];
      label = [{
        text = "$TIME";
        font_size = 90;
        position = "0, 200";
        halign = "center";
        valign = "center";
      }];
    };
  };
}
