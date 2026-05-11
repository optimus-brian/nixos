{ config, pkgs, lib, inputs, ... }:

{
  # Surface Laptop 5 (Gen 5, 2022, Intel 12. Gen)
  # microsoft-surface-common rausgenommen — triggert Kernel-Rebuild der >1h dauert.
  # Stattdessen Standard-Kernel aus Cache. Touchscreen via libinput, Pen-Support
  # können wir später nachrüsten wenn nötig.

  # Standard-Kernel (latest LTS) aus Cache → kein Build
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
      # Akku lädt bis 100% (vorher 75-90% Akku-Schon, hat Brian gestört)
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

  # Zram = komprimiertes RAM-Swap.
  # Bei 8GB Surface gibt das ~4GB extra "virtuellen" RAM ohne SSD-IO.
  # zstd-Kompression ~3:1 → 50% RAM-Reserve werden zu ~12GB effektiv.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;     # max. 50% RAM als zram (= 4GB von 8GB)
  };
}
