{
  description = ''
    Quitlox's Raspberry Pi
  '';

  nixConfig = {
    bash-prompt = "\[nixos-raspberrypi-demo\] ➜ ";
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    connect-timeout = 5;
  };

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
    };
  };

  outputs = { self, nixpkgs
            , nixos-raspberrypi
            , ... }@inputs: let
    allSystems = nixpkgs.lib.systems.flakeExposed;
    forSystems = systems: f: nixpkgs.lib.genAttrs systems (system: f system);       
  in {

    nixosConfigurations = let

      users-config-stub = ({ config, ... }: {
        # This is identical to what nixos installer does in
        # (modulesPash + "profiles/installation-device.nix")

        # Use less privileged nixos user
        users.users.quitlox = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
	  # Allow the graphical user to login without password
	  initialHashedPassword = "";
        };

	# Allow the user to log in as root without a passwd.
	users.users.root.initialHashedPassword = "";

        # Don't require sudo/root to `reboot` or `poweroff`.
        security.polkit.enable = true;

        # Automatically log in at the virtual consoles.
        # services.getty.autologinUser = "quitlox";

        # We run sshd by default. Login is only possible after adding a
        # password via "passwd" or by adding a ssh key to ~/.ssh/authorized_keys.
        # The latter one is particular useful if keys are manually added to
        # installation device for head-less systems i.e. arm boards by manually
        # mounting the storage in a different system.
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };

        # allow nix-copy to live system
        nix.settings.trusted-users = [ "quitlox" ];

        # We are stateless, so just default to latest.
        system.stateVersion = config.system.nixos.release;
      });

      network-config = {
        # This is mostly portions of safe network configuration defaults that
        # nixos-images and srvos provide

        networking.useNetworkd = true;
        # mdns
        networking.firewall.allowedUDPPorts = [ 5353 ];
        systemd.network.networks = {
          "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
          "99-wireless-client-dhcp".networkConfig.MulticastDNS = "yes";
        };

        # This comment was lifted from `srvos`
        # Do not take down the network for too long when upgrading,
        # This also prevents failures of services that are restarted instead of stopped.
        # It will use `systemctl restart` rather than stopping it with `systemctl stop`
        # followed by a delayed `systemctl start`.
        systemd.services = {
          systemd-networkd.stopIfChanged = false;
          # Services that are only restarted might be not able to resolve when resolved is stopped before
          systemd-resolved.stopIfChanged = false;
        };

        # Use iwd instead of wpa_supplicant. It has a user friendly CLI
        networking.wireless.enable = false;
        networking.wireless.iwd = {
          enable = true;
          settings = {
            Network = {
              EnableIPv6 = true;
              RoutePriorityOffset = 300;
            };
            Settings.AutoConnect = true;
          };
        };
      };

      common-user-config = {config, pkgs, ... }: {
        imports = [
          users-config-stub
          network-config
        ];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
        time.timeZone = "UTC";
        networking.hostName = "quitlox-pi";

        services.udev.extraRules = ''
          # Ignore partitions with "Required Partition" GPT partition attribute
          # On our RPis this is firmware (/boot/firmware) partition
          ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
            ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
            ENV{UDISKS_IGNORE}="1"
        '';

        environment.systemPackages = with pkgs; [
          tree
          curl
          wget
          git
          vim
          neovim

	  gnupg
            pinentry-curses
            rbw
            chezmoi
        ];


        users.users.quitlox.openssh.authorizedKeys.keys = [
          # YOUR SSH PUB KEY HERE #

        ];
        users.users.root.openssh.authorizedKeys.keys = [
          # YOUR SSH PUB KEY HERE #
          
        ];
	
	programs.gnupg.agent = {
	  enable = true;
	};


      };
    in {

      quitlox-pi = nixos-raspberrypi.lib.nixosSystemFull {
        specialArgs = inputs;
        modules = [
          ({ config, pkgs, lib, nixos-raspberrypi, ... }: {
            imports = with nixos-raspberrypi.nixosModules; [
              # Hardware configuration
              raspberry-pi-5.base
              raspberry-pi-5.display-vc4
              raspberry-pi-5.bluetooth
              ./pi5-configtxt.nix
            ];
          })

          # FILE SYSTEM
          ({ ... }: {
	    fileSystems."/" =
	      { device = "/dev/disk/by-label/NIXROOT";
		fsType = "ext4";
		options = [ "noatime" ];
	      };

	    fileSystems."/boot/firmware" =
	      { device = "/dev/disk/by-label/NIXBOOT";
		fsType = "vfat";
		options = [ "fmask=0022" "dmask=0022" "noatime" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=1min" ];
	      };
          })

          {
            boot.tmp.useTmpfs = true;
          }

          # USER CONFIG
          common-user-config

	  # REQUIRED: Do not touch
          ({ config, pkgs, lib, ...}: {
	    system.nixos.tags = let
		    cfg = config.boot.loader.raspberryPi;
	    in [
		    "raspberry-pi-${cfg.variant}"
		    cfg.bootloader
		    config.boot.kernelPackages.kernel.version
	    ];
          })

        ];
      };

    };

  };
}
