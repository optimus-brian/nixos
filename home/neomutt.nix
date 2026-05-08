{ config, pkgs, ... }:

{
  # Mail-Stack: himalaya (CLI-Mail-Tool, modern) + neomutt (klassischer TUI).
  # Du kannst beide nutzen — himalaya für quick-checks, neomutt für volle Sessions.
  # Account-Setup machen wir gemeinsam auf dem Surface (Mailbox-Pfade,
  # IMAP-Server, OAuth ggf.).

  programs.himalaya = {
    enable = true;
    settings = {
      display-name = "Brian Rieth";
      # Account-Beispiel — Details auf dem Surface anpassen:
      # accounts.icloud = {
      #   email = "rieth@me.com";
      #   imap = { ... };
      #   smtp = { ... };
      # };
    };
  };

  programs.neomutt = {
    enable = true;
    sidebar.enable = true;
    sidebar.width = 25;
    sidebar.shortPath = true;

    # Catppuccin-Mocha-Farben passend zum Hyprland-Look
    extraConfig = ''
      # Look
      set sort = reverse-date
      set sort_aux = last-date-received
      set markers = no
      set mark_old = no
      set mailcap_path = ~/.config/neomutt/mailcap
      set rfc2047_parameters = yes

      # HTML-Mails via lynx im Terminal rendern
      auto_view text/html
      alternative_order text/plain text/enriched text/html

      # Sidebar
      set sidebar_visible = yes
      set sidebar_format = "%D%?F? [%F]?%* %?N?%N/?%S"
      set mail_check_stats
      bind index,pager \\Cn sidebar-next
      bind index,pager \\Cp sidebar-prev
      bind index,pager \\Co sidebar-open

      # Catppuccin Mocha Theme
      color normal      default default
      color indicator   color255 color61
      color tree        color61  default
      color status      color250 color236
      color sidebar_indicator color255 color61
      color sidebar_highlight color235 color250
      color sidebar_new color76  default
      color error       color203 default
      color warning     color214 default
      color tilde       color242 default
      color message     color203 default
      color search      color255 color61
      color attachment  color255 color61
      color hdrdefault  color61  default
      color quoted      color61  default
      color signature   color61  default
      color bold        color255 default
      color underline   color255 default
    '';
  };

  # Helfer: lynx fürs HTML-Rendering, w3m als Fallback, msmtp/isync für IMAP-Sync später
  home.packages = with pkgs; [
    lynx
    w3m
    isync          # mbsync — IMAP-Sync nach Maildir
    msmtp          # SMTP-Client
    notmuch        # Volltext-Mail-Suche
    pass           # Passwort-Store für Mail-Credentials
    gnupg
    libsecret
  ];

  # Mailcap (HTML-Anhänge etc.)
  xdg.configFile."neomutt/mailcap".text = ''
    text/html; lynx -assume_charset=%{charset} -display_charset=utf-8 -dump %s; copiousoutput; nametemplate=%s.html
    image/*;   feh %s
    application/pdf; zathura %s
  '';
}
