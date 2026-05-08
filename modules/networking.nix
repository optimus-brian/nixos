{ config, pkgs, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  # WireGuard (kommt eh — Homelab-VPN!)
  environment.systemPackages = with pkgs; [
    wireguard-tools
    networkmanager-openvpn
  ];
}
