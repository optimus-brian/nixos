{ config, pkgs, ... }:

{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "s";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "p";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
      * {
        background-image: none;
        font-family: "JetBrains Mono", monospace;
        font-size: 16px;
        transition: 200ms;
      }

      window {
        background-color: rgba(11, 27, 42, 0.92);
      }

      button {
        color: #D7DCE2;
        background-color: rgba(26, 47, 69, 0.6);
        border: 2px solid #1F5C85;
        border-radius: 12px;
        margin: 16px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active, button:hover {
        background-color: rgba(31, 92, 133, 0.4);
        border-color: #7FB8DC;
        color: #F3F1EC;
        outline-style: none;
      }

      #lock     { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
      #logout   { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
      #suspend  { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
      #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
      #reboot   { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
    '';
  };
}
