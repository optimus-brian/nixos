{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    # WezTerm-Config in Lua — Sidebar-Tabs (vertikal links)
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      -- rieth.io Brand-Farben (custom dark scheme aus styleguide)
      config.colors = {
        foreground = '#D7DCE2',  -- r-rule
        background = '#0B1B2A',  -- r-ink
        cursor_bg  = '#7FB8DC',  -- r-blue-tint
        cursor_border = '#7FB8DC',
        cursor_fg  = '#0B1B2A',
        selection_bg = '#1F5C85',
        selection_fg = '#FFFFFF',
        ansi = {
          '#1A2F45',  -- 0 black (r-ink-2)
          '#B4361A',  -- 1 red (r-danger)
          '#1F7A4D',  -- 2 green (r-ok)
          '#B57B1A',  -- 3 yellow (r-warn)
          '#1F5C85',  -- 4 blue (r-blue)
          '#7FB8DC',  -- 5 magenta → r-blue-tint
          '#7FB8DC',  -- 6 cyan
          '#D7DCE2',  -- 7 white (r-rule)
        },
        brights = {
          '#4A5A6E',  -- bright black (r-ink-3)
          '#B4361A',
          '#1F7A4D',
          '#B57B1A',
          '#7FB8DC',
          '#7FB8DC',
          '#D7DCE2',
          '#FFFFFF',
        },
        tab_bar = {
          background = '#0B1B2A',
          active_tab = { bg_color = '#1F5C85', fg_color = '#FFFFFF' },
          inactive_tab = { bg_color = '#1A2F45', fg_color = '#8795A4' },
          inactive_tab_hover = { bg_color = '#164361', fg_color = '#D7DCE2' },
          new_tab = { bg_color = '#1A2F45', fg_color = '#7FB8DC' },
          new_tab_hover = { bg_color = '#1F5C85', fg_color = '#FFFFFF' },
        },
      }
      config.font = wezterm.font_with_fallback {
        'JetBrainsMono Nerd Font',
        'Symbols Nerd Font',
      }
      config.font_size = 12.0
      config.line_height = 1.1

      -- Wayland-native (kein XWayland)
      config.enable_wayland = true

      -- Fenster: schlank, kein Titel-Krempel
      config.window_decorations = 'RESIZE'
      config.window_padding = { left = 8, right = 8, top = 4, bottom = 4 }
      config.window_background_opacity = 0.92
      config.use_fancy_tab_bar = false

      -- ❤️ SIDEBAR-TABS LINKS — der Trick:
      -- WezTerm hat keine eingebaute "linke Sidebar" für Tabs,
      -- aber via tabline + custom layout kann man das simulieren.
      -- Pragmatischer: Tabs oben (klassisch) + Pane-Splits + Fancy-Tab-Bar aus.
      -- Falls du echte Sidebar willst: zellij verwenden (Bind unten).
      config.tab_bar_at_bottom = false
      config.hide_tab_bar_if_only_one_tab = true
      config.tab_max_width = 32
      config.show_new_tab_button_in_tab_bar = true
      config.tab_and_split_indices_are_zero_based = false

      -- Keybindings (macOS-Muscle-Memory: CMD → ALT auf Linux)
      local act = wezterm.action
      config.keys = {
        -- Tabs
        { key = 't', mods = 'ALT',       action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'w', mods = 'ALT',       action = act.CloseCurrentTab { confirm = true } },
        { key = 'Tab', mods = 'CTRL',    action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

        -- Panes (Splits)
        { key = 'd', mods = 'ALT',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'd', mods = 'ALT|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = 'h', mods = 'ALT',       action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'ALT',       action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'ALT',       action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'ALT',       action = act.ActivatePaneDirection 'Down' },
        { key = 'x', mods = 'ALT',       action = act.CloseCurrentPane { confirm = true } },

        -- Copy/Paste
        { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
        { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

        -- Zellij-Sidebar starten (echte vertikale Tabs!)
        { key = 'z', mods = 'ALT', action = act.SpawnCommandInNewTab { args = { 'zellij' } } },

        -- Quick-Search
        { key = 'f', mods = 'CTRL|SHIFT', action = act.Search { CaseInSensitiveString = "" } },
      };

      config.scrollback_lines = 10000
      config.audible_bell = 'Disabled'
      config.default_cursor_style = 'BlinkingBar'

      return config
    '';
  };

  # Zellij — bringt ECHTE Sidebar-Tabs (vertikale Tab-Liste links).
  # Start mit ALT+Z aus WezTerm, oder einfach `zellij` im Terminal.
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;  # nicht auto-attach, nur on-demand
    settings = {
      # zellij theme kommt aus catppuccin-Modul
      default_layout = "compact";
      simplified_ui = false;
      pane_frames = true;
      copy_command = "wl-copy";
      copy_clipboard = "system";
    };
  };
}
