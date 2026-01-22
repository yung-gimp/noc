{ lib, ... }:
{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "sd_mod"
      "atkbd"
      "i8042"
    ];
    kernelModules = [ "kvm-intel" ];
  };
  hardware.enableRedistributableFirmware = true;
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  services = {
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance"; # performance powersave
          energy_performance_preference = "performance"; # default performance balance_performance balance_power power
          energy_perf_bias = "balance_performance"; # performance (0), balance_performance (4), default (6), balance_power (8), or power (15)
          platform_profile = "performance";
          # scaling_min_freq = 800000
          # scaling_max_freq = 1000000
          tubo = "auto"; # always, auto, never
        };
        battery = {
          governor = "powersave";
          energy_performance_preference = "power";
          energy_perf_bias = "balance_power";
          platform_profile = "low-power";
          # scaling_min_freq = 800000
          # scaling_max_freq = 1000000
          tubo = "auto";
        };
      };
    };
  };
  specialisation.on-the-go.configuration = {
    system.nixos.tags = [ "on-the-go" ];
    hardware.nvidia.prime = {
      offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = lib.mkForce true;
      };
      sync.enable = lib.mkForce false;
    };
  };
  freedpom.hardware.displays = {
    "eDP-1" = {
      includeKernelParams = true;
      resolution = {
        width = 1080;
        height = 1920;
      };
      framerate = 144;
      vrr = 3;
      colorProfile = "auto";
      colorDepth = 32;
      workspaces = [
        "1"
        "2"
        "3"
        "4"
      ];
    };
  };
}
