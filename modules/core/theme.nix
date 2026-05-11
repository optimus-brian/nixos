{ config, lib, ... }:

{
  # Single source of truth fürs Theming.
  # Ändere hier und alle Programme ziehen mit.
  catppuccin = {
    enable = true;          # System-weite Defaults (Konsole, etc.)
    flavor = "mocha";
    accent = "mauve";
    cache.enable = true;    # Binary-Cache (catppuccin.cachix.org) — viele kleine Theme-Builds
  };
}
