{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    systemd.variables = [ "--all" ];

    settings = {
      # Surface Laptop 5: 2256x1504 — Scale 1.6 = 1410x940 (saubere Integer-Math, lesbar)
      monitor = [ ", preferred, auto, 1.6" ];

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
        # waybar läuft als systemd user service (programs.waybar.systemd.enable)
        "mako"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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
        };
      };

      # Gestures (Hyprland 0.50+ neue Syntax) — erstmal weg, später zurück
      # gesture = [ "3, horizontal, workspace" ];

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

      # windowrule: aktuelle Hyprland-Syntax ist anders, später nachrüsten
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
        position = "0, -100";
        monitor = "";
        dots_center = true;
        fade_on_empty = true;
        outline_thickness = 2;
        outer_color = "rgba(203, 166, 247, 0.8)";
        inner_color = "rgba(30, 30, 46, 0.8)";
        font_color = "rgba(205, 214, 244, 1)";
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
