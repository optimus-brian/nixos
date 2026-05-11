{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = (with pkgs; [
    # === Daily Drivers ===
    obsidian
    firefox
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    gvfs
    chromium
    iwgtk            # WiFi-GUI mit Klartext-Liste

    # === Editors / IDE ===
    # vscode kommt via programs.vscode unten (mit Extensions)
    # neovim kommt via programs.neovim unten

    # === Development ===
    nodejs_22
    python313
    python313Packages.pip
    python313Packages.virtualenv
    uv
    rustup
    go
    docker-compose
    kubectl
    kubernetes-helm
    k9s
    just
    gnumake

    # === CLI-Power ===
    jq
    yq
    fd
    sd
    dust
    duf
    procs
    bottom
    tldr
    bandwhich
    zellij
    tmux
    sshfs

    # === Media ===
    mpv
    imv
    feh
    zathura
    yt-dlp
    ffmpeg

    # === Productivity ===
    libreoffice-fresh

    # === Comms ===
    discord
    signal-desktop
    telegram-desktop

    # === Screenshot / Color ===
    hyprshot
    grimblast
    gpick

    # === Sync / Cloud ===
    rclone
    syncthing

    # === Surface / Hardware ===
    iio-sensor-proxy
    iotop
    powertop

    # === Network (Homelab) ===
    nmap
    inetutils
    dig
    mtr
    iperf3
    tcpdump
    socat
  ]);

  # Neovim mit Basis-Setup (LazyVim-ready)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      ripgrep
      fd
      tree-sitter
      lua-language-server
      nil
      nixd
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      pyright
    ];
  };

  # Direnv (Auto-Activation von dev-Shells)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # SSH-Config (private hosts)
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      Host *
        ServerAliveInterval 60
        ServerAliveCountMax 3
    '';
  };

  # Syncthing für Vault-Sync
  services.syncthing = {
    enable = true;
  };

  # Mako als systemd-user-Service (statt exec-once in Hyprland)
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      anchor = "top-right";
      margin = "12";
      border-radius = 8;
      border-size = 2;
      max-icon-size = 48;
      font = "Inter 11";
      # Farben kommen von services.mako.catppuccin.enable in theme.nix
    };
  };
}
