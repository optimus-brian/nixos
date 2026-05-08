{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    # === Daily Drivers ===
    obsidian
    firefox
    thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    gvfs

    # Browser-Alternativen
    chromium

    # === Editors / IDE ===
    pkgs-unstable.code-cursor   # Cursor (AI-Editor) — aus unstable für aktuelle Version
    vscode
    neovim

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
    dust          # bessere du
    duf           # bessere df
    procs         # bessere ps
    bottom        # bessere top
    glances
    tldr
    bandwhich
    zellij
    tmux
    sshfs

    # === Media ===
    mpv
    imv           # Wayland-Image-Viewer
    feh
    zathura       # PDF
    yt-dlp
    ffmpeg

    # === Productivity ===
    libreoffice-fresh
    obsidian
    todoist-electron

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

    # === Surface-spezifisch / Hardware ===
    iio-sensor-proxy   # Auto-Rotate (Surface dreht sich!)
    iotop
    powertop
    s-tui              # CPU-Stress-Test + Monitor

    # === Pentest / Network (du bist Homelab-Guy) ===
    nmap
    inetutils
    dig
    mtr
    iperf3
    tcpdump
    socat

    # === Obsidian-CLI ===
    # offizielle obsidian-CLI ist nicht in nixpkgs — installierst du via npm,
    # oder wir packen sie später als overlay.
    # Fallback: obsidian-cli (yakitrak) gibt's via cargo.
  ];

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
      nil           # Nix LSP
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

  # SSH-Config (nutzt deinen vorhandenen Key)
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      Host pve
        HostName 192.168.10.1
        User root

      Host signage
        HostName 192.168.111.196
        Port 2222
        User pi

      Host onedev.rieth.io
        IdentityFile ~/.ssh/id_ed25519

      Host *
        ServerAliveInterval 60
        ServerAliveCountMax 3
    '';
  };

  # Syncthing für Vault-Sync (parallel zu iCloud)
  services.syncthing = {
    enable = true;
  };
}
