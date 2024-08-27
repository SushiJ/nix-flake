{
  inputs,
  username,
  password,
  pkgs
}: system:
let
  configuration = import ../module/configuration.nix;
  hardware-configuration = import ../module/hardware-configuration.nix;
  home-manager = import ../module/home-manager.nix;
  # pkgs = inputs.nixpkgs.legacyPackages.${system};
  unstable = import <nix-unstable> { config = { allowUnfree = true; }; };
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    modules = [
      hardware-configuration
      configuration

      {
        boot.loader = {
          efi  = {
            canTouchEfiVariables = true;
          };
          grub = {
            efiSupport = true;
            enable = true;
            device = "nodev";
            useOSProber = true;
          };
        };

        nixpkgs.config.allowUnfree = true;

        time.timeZone = "Asia/Kolkata";

        i18n.defaultLocale = "en_IN";

        i18n.extraLocaleSettings = {
          LC_ADDRESS = "en_IN";
          LC_IDENTIFICATION = "en_IN";
          LC_MEASUREMENT = "en_IN";
          LC_MONETARY = "en_IN";
          LC_NAME = "en_IN";
          LC_NUMERIC = "en_IN";
          LC_PAPER = "en_IN";
          LC_TELEPHONE = "en_IN";
          LC_TIME = "en_IN";
        };

        services = {
          pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
          };
          openssh.enable = true;
          openssh.settings.PasswordAuthentication = false;
          openssh.settings.PermitRootLogin = "no";
          xserver = {
            enable = true;
            xkb = {
              layout = "us";
              variant = "";
            };
            desktopManager.plasma5.enable = true;
            windowManager.bspwm.enable = true;
            videoDrivers = ["nvidia"];
          };
          displayManager.sddm.enable = true;
          udev.extraRules = "";
          gvfs.enable = true;
        };

        xdg.mime.defaultApplications = {
          "inode/directory" = "thunar.desktop";
        };

        users.users."${username}" = {
          extraGroups = ["networkmanager" "wheel" "disk" "storage" "video"];
          home = "/home/${username}";
          isNormalUser = true;
          password = password;
          shell = pkgs.fish;
        };
        programs.fish.enable = true;

        networking = {
          hostName = "nixos";
          networkmanager.enable = true;
        };

        security.sudo.enable = true;
        security.polkit.enable = true;
        security.sudo.wheelNeedsPassword = false;
        security.rtkit.enable = true;

        sound.enable = true;

        programs.firefox.enable = true;

        environment.systemPackages = with pkgs; [
          alacritty
          bspwm
          bat
          clang
          dmenu-rs
          eza
          fd
          fish
          feh
          fzf
          gcc
          google-chrome
          herbstluftwm
          jq
          pcmanfm
          mpv
          cinnamon.nemo
          nitrogen
          openssl
          unstable.neovim
          polybar
          polkit
          polkit_gnome
          ripgrep
          sxhkd
          unzip
          udisks2
          udiskie
          vim
          wget
          wpa_supplicant
          qbittorrent
          sqlite
          xclip
          xfce.thunar
          xfce.thunar-volman
          zip
          zoxide
          zed-editor

          # Languages / tools
          rustup
          go
          nodejs_20
          unstable.pnpm
          python3
          odin
          zig
          erlang_27
          unstable.elixir_1_17
          unstable.gleam
          vala
          unstable.bun
          lua
          ghc
          devenv
          #WARN: Remove this after
          stripe-cli
        ];

        systemd = {
          user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
              Type = "simple";
              ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
              Restart = "on-failure";
              RestartSec = 1;
              TimeoutStopSec = 10;
            };
          };
        };
      }

      inputs.home-manager.nixosModules.home-manager
      {
        # add home-manager settings here
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${username}" = home-manager;
      }
    ];
  }
