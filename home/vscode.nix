{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Sprachen / LSPs (alle stabil in nixpkgs)
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        rust-lang.rust-analyzer
        golang.go
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        editorconfig.editorconfig

        # Git
        eamodio.gitlens
        github.vscode-pull-request-github
        github.copilot
        github.copilot-chat

        # Theme (passt zu rieth.io dark)
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons

        # Productivity
        usernamehw.errorlens
        christian-kohler.path-intellisense
        streetsidesoftware.code-spell-checker

        # Container/K8s
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools

        # Markdown
        yzhang.markdown-all-in-one
      ];

      userSettings = {
        # Optik
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "editor.fontFamily" = "'JetBrains Mono', 'JetBrainsMono Nerd Font', monospace";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.5;
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "workbench.list.smoothScrolling" = true;

        # Verhalten
        "files.autoSave" = "onFocusChange";
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.renderWhitespace" = "boundary";
        "editor.rulers" = [ 80 120 ];

        # Telemetry aus, Auto-Update aus (kommt via Nix)
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
        "update.mode" = "none";

        # Terminal
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "terminal.integrated.defaultProfile.linux" = "zsh";

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";

        # Sprachen-Defaults
        "[python]"."editor.defaultFormatter" = "ms-python.python";
        "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[markdown]"."editor.wordWrap" = "on";

        # ErrorLens
        "errorLens.enabled" = true;
        "errorLens.gutterIconsEnabled" = true;
      };
    };
  };
}
