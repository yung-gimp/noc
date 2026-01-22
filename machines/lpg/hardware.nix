{
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "hid-generic"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-amd" ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  freedpom.hardware.displays = {
    "DP-1" = {
      includeKernelParams = true;
      resolution = {
        width = 2560;
        height = 1440;
      };
      framerate = 165;
      vrr = 3;
      colorProfile = "auto";
      colorDepth = 32;
      identifiers.description = "ASUSTek COMPUTER INC VG32VQ1B S9LMTF038670";
      workspaces = [
        "1"
        "2"
        "3"
        "4"
      ];
    };
    "DP-2" = {
      resolution = {
        width = 2560;
        height = 1440;
      };
      framerate = 165;
      vrr = 3;
      colorProfile = "auto";
      colorDepth = 32;
      identifiers.description = "ASUSTek COMPUTER INC ASUS VG32VQ1B 0x0003A472";
      workspaces = [
        "5"
        "6"
        "7"
        "8"
      ];
    };
  };

}
