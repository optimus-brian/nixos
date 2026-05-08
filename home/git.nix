{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Brian Rieth";
    userEmail = "rieth@me.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
      rerere.enabled = true;
    };

    aliases = {
      st = "status -sb";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --graph --oneline --decorate --all";
      last = "log -1 HEAD --stat";
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
        syntax-theme = "Catppuccin-mocha";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui.theme = {
      activeBorderColor = [ "magenta" "bold" ];
      inactiveBorderColor = [ "default" ];
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
