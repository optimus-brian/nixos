{ config, pkgs, lib, inputs, ... }:

{
  # Surface Laptop 5 (Gen 5, 2022, Intel 12. Gen)
  # Basis-Hardware-Module aus nixos-hardware. Touch + Pen via IPTSD
  # können wir später als Overlay nachrüsten — erstmal solide Basis.
  imports = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];

  # Kernel kommt aus nixos-hardware/microsoft/surface/common — nicht überschreiben.

  # Firmware (WiFi, Bluetooth, Graphics)
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Power-Management — Surface profitiert massiv
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 90;
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
    };
  };

  services.thermald.enable = true;
  services.fwupd.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  services.blueman.enable = true;

  # Touchpad / Touch
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

  # systemd-boot (Surface mag UEFI)
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };
}
