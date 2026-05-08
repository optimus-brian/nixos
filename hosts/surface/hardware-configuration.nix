# Diese Datei wird beim ersten Boot vom NixOS-Installer überschrieben.
# Workflow:
#   1. Minimal-ISO booten
#   2. nixos-generate-config --root /mnt
#   3. Diese Datei mit dem Output von /mnt/etc/nixos/hardware-configuration.nix ersetzen
#   4. nixos-install --flake .#surface
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Wird vom Installer befüllt:
  # boot.initrd.availableKernelModules = [ ... ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ "kvm-intel" ];
  # fileSystems."/" = { device = "/dev/disk/by-uuid/..."; fsType = "ext4"; };
  # fileSystems."/boot" = { device = "/dev/disk/by-uuid/..."; fsType = "vfat"; };
  # swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
