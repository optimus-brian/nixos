{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      share = true;
      extended = true;
    };

    shellAliases = {
      ll = "eza -l --git --icons";
      la = "eza -la --git --icons";
      lt = "eza --tree --icons";
      bcat = "bat";
      cd = "z";
      grep = "rg";
      vim = "nvim";

      # NixOS-Workflows
      nrs = "sudo nixos-rebuild switch --flake .#surface";
      nrt = "sudo nixos-rebuild test --flake .#surface";
      nrb = "sudo nixos-rebuild boot --flake .#surface";
      nfu = "nix flake update";
      nfs = "nix flake show";
      ngc = "sudo nix-collect-garbage -d";
    };

    initContent = ''
      # FZF + Zoxide
      eval "$(fzf --zsh)"
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"

      # Atuin (history sync, optional)
      [ -x "$(command -v atuin)" ] && eval "$(atuin init zsh)"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "[](mauve)$os$username$hostname[](mauve) $directory$git_branch$git_status$nix_shell$python$nodejs$rust$cmd_duration$line_break$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = { truncation_length = 4; truncate_to_repo = true; };
      nix_shell = { format = "[$symbol$state]($style) "; symbol = "❄️ "; };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  # bat-Theme wird vom catppuccin-Modul gesetzt

  programs.eza.enable = true;
  programs.ripgrep.enable = true;
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}
