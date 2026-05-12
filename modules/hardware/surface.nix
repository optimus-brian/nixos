{ config, pkgs, lib, inputs, ... }:

{
  # Surface Laptop 5 (Gen 5, 2022, Intel 12. Gen)
  # Surface-spezifische Kernel-Module + Patches via linux-surface Projekt.
  # Erster Build dauert ~30-60 Min (Kernel + Hyprland-Komponenten neu).
  imports = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];

  # Kernel kommt aus microsoft-surface-common (linux-surface Patches)

  # Shutdown-Hang Fix (Intel 12th Gen Surface: SL5, SP9, SL6, SP11)
  # Symptom: poweroff erreicht Power-Off-Target, aber Hardware schaltet nicht ab,
  # CPU/Lüfter laufen weiter. Ursache: EFI_RESET_SHUTDOWN hängt weil PCI-Shutdown-
  # Callbacks (TB4/iGPU) vor dem Firmware-Call laufen.
  # Fix: reboot=acpi zwingt ACPI-Reset-Pfad statt EFI-Reset.
  # Refs: linux-surface#1864, r/SurfaceLinux NixOS-Reports 2026.
  boot.kernelParams = [
    "pci=hpiosize=0"              # verhindert ACPI-GPE-Spam beim Shutdown
    "acpi=force"                  # ACPI auch wenn Tabellen unsauber
    "reboot=acpi"                 # ACPI-Reset statt EFI-Reset (entscheidend!)
    "acpi_sleep=nonvs"            # Bonus: Suspend-S0ix→S5-Hang vermeiden
    ''acpi_osi="Windows 2020"''   # SL5/SP9 quirks zielen auf 2020-Profil
  ];

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

  # Brightness ohne sudo: video-Group darf /sys/class/backlight/*/brightness schreiben
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # tmpfiles als Fallback wenn udev-Rule beim Boot zu spät kommt
  systemd.tmpfiles.rules = [
    "z /sys/class/backlight/intel_backlight/brightness 0664 root video - -"
  ];

  # Zram = komprimiertes RAM-Swap.
  # Bei 8GB Surface gibt das ~4GB extra "virtuellen" RAM ohne SSD-IO.
  # zstd-Kompression ~3:1 → 50% RAM-Reserve werden zu ~12GB effektiv.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;     # max. 50% RAM als zram (= 4GB von 8GB)
  };
}
