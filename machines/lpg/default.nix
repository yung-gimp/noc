{
  config,
  inputs,
  lib,
  self,
  pkgs,
  ...
}:
{
  freedpom = {
    windowManagers.hyprland.enable = true;
    services = {
      ananicy.enable = true;
      vr = {
        enable = true;
        bitrate = 150000000;
        autoStart = true;
      };

      consoles = {
        enable = true;
        getty = [
          "codman@tty1"
          "tty3"
        ];
        kmscon = [ "tty2" ];
      };
    };

    system = {
      nix.enable = true;
      performance.enable = true;
      boot.enable = true;
      preservation = {
        enable = true;
        preserveHome = true;
      };
      users.users.codman = {
        role = "admin";
        tags = [ "base" ];
        preservation.directories = [
          ".local/share/Terraria"
        ];
        userOptions = {
          uid = 1000;
          hashedPasswordFile = config.age.secrets.password.path;
          extraGroups = [
            "podman"
            "libvirtd"
            "dialout"
          ];
        };
      };
    };
  };

  cm.programs = {
    steam.enable = true;
  };

  networking.networkmanager.enable = true;

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  home-manager.users.codman = {
    home.stateVersion = "25.05";
    imports = [
      self.homeModules.codmod
      inputs.ff.homeModules.default
      inputs.ff.homeModules.windowManagers
    ];

    freedpom = {
      programs.bash.enable = true;
      windowManagers.hyprland.enable = true;
    };

    cm = {
      hyprland.enable = true;
      programs = {
        firefox.enable = true;
        git.enable = true;
        # media.enable = true;
        nvf.enable = true;
        foot.enable = true;
        zsh.enable = true;
        bemenu.enable = true;
      };
    };
  };

  boot = {
    loader.systemd-boot.configurationLimit = lib.mkForce 25;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth = {
      theme = "spinner_alt";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "spinner_alt" ];
        })
      ];
    };
  };

  fonts = {
    fontconfig.defaultFonts.monospace = [ "BlexMono Nerd Font Mono" ];
    packages = with pkgs; [
      noto-fonts
      liberation_ttf
      nerd-fonts.iosevka-term-slab
      nerd-fonts.blex-mono
    ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  programs.virt-manager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.nitrokey.enable = true;

  services = {
    flatpak.enable = true;
  };

  systemd.tmpfiles.rules = [
    "d /home/codman 0750 codman users" # should maybe add to preservation
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };

  fileSystems."/home/codman/games" = {
    depends = [ "/nix/persist/games" ];
    device = "/nix/persist/games";
    fsType = "none";
    options = [ "bind" ];
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "qtwebengine-5.15.19" ];
    };
  };
  system.stateVersion = "25.05";

  imports = [
    ./audio.nix
    ./disko.nix
    ./hardware.nix
    inputs.secrets.nixosModules.lpg
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];
}
