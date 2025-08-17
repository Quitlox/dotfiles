# Raspberry Pi 5 NixOS

The state of running NixOS on a Raspberry Pi 5 is a bit of a mess. There used to
be official support for NixOS on Raspberrys, but given the complexities and the
proprietary firmware of the Pis, support was dropped. (I think) With this, the
community project (https://github.com/nix-community/raspberry-pi-nix) was
archived.

There are multiple routes to manually getting NixOS running on a Pi (5). The
thread where this was most discussed seems to be [this Github issue](https://github.com/NixOS/nixpkgs/issues/260754). 
This discussion is partly documented on the [wiki here](https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_5#Proposed_Solution).
In summary, the most viable and straightforward route is to use [nvmd/nixos-raspberrypi](https://github.com/nvmd/nixos-raspberrypi).

This repository provides a nix flake that is can be used as your NixOS
configuration. The flake can both produce "installer images" (with some
configuration to make it useful as an installer), or be used directly as your pi
system configuration.

## Bootstrapping

At the time of writing (2025-08-02), there are no prebuilt images provided by
[nvmd/nixos-raspberrypi](https://github.com/nvmd/nixos-raspberrypi). This is
annoying, because the Raspberry Pi 5 has an `AArch64` architecture, which you
will (probably) not find in your desktop. We thus have to built the image
ourselves _using the Pi as the building platform_.

Steps:
1. Download a Raspberry Pi OS (or any other pre-built) image and flash it to the SD Card
    * You can either manually flash the image
        * `gunzip -c <raspberry-pi-os-image>.img.gz | sudo dd of=/dev/sdX bs=4M status=progress` (replace `/dev/sdX`)
    * Or use the `rpi-imager` (recommended)
        * This tool allows you to easily configure internet (WiFi), account and SSH, meaning you won't have to hook it up to a monitor
2. Install & Configure `Nix`
    1. `sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon`
        * Installing `Nix` by default is done with the command  (see [installation](https://nixos.org/download/)).
    2. `bash ./bootstrap/setup_nix_nvme.bash` (well, you first need to copy over the script or something)
        * We will need to use our NVMe drive as `/nix`-store, as the SD Card (of 16GB) does not have enough disk space to build the NixOS image.
        * The script `./bootstrap/setup_nix_nvme.bash` format the NVMe drive and move over the `/nix`-store
3. Build the NixOS Image on the Pi
    1. Clone the repository `git clone git@github.com:nvmd/nixos-raspberrypi.git`
    2. Build the image using `nix build ".#installerImages.rpi5"` (no changes necessary)
    3. Copy over the image to the desktop
    4. Flash the NixOS image onto the SD Card
        * As far as I can tell, flashing the directly to the NVMe from the Pi will not work.
4. Boot into the Installer Image
    * (You can _somewhat_ follow [NixOS Installation Guide](https://nixos.wiki/wiki/NixOS_Installation_Guide) here, or just follow my instructions)
    1. Configure WiFi (or plug-in ethernet)
        * Use the `iwctl` tool to setup Wifi:
            1. Launch `iwctl` (launches TUI)
            2. Type `station wlan0 connect "<SSID>` 
                * alternatively `station wlan0 scan` and `station wlan0 get-networks`
    2. Partition the NVMe (follow the [NixOS Installation Guide](https://nixos.wiki/wiki/NixOS_Installation_Guide) until mounting, specifically "Partitioning - UEFI" and "Label partitions")
    3. Mount the partitions (DEVIATES FROM GUIDE)
        * `sudo mount /dev/disk/by-label/NIXROOT /mnt`
        * `sudo mkdir -p /mnt/boot/firmware`
        * `sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot/firmware`
    4. "Generate the configuration"
        * Using `sudo nixos-generate-config --root /mnt` you can now generate
          `/etc/nixos/configuration.nix` and
          `/etc/nixos/hardware-configuration.nix`. 
        * This is handy, as the `hardware-configuration.nix` will contain the
          filesystem configuration we will need to copy over to our own
          configuration. But, as you may now, the `configuration.nix` file is the
          legacy way of configuring NixOS. We will use a flake-based approach, and
          base ourselves on the flake provided by
          [nvmd/nixos-raspberrypi](https://github.com/nvmd/nixos-raspberrypi).
    5. Copy over `flake.nix` from [nvmd/nixos-raspberrypi-demo](https://github.com/nvmd/nixos-raspberrypi-demo/tree/main) to `/mnt/etc/nixos/flake.nix`.
        * You should see that as just an example file containing various options and methods for configuring [nvmd/nixos-raspberrypi](https://github.com/nvmd/nixos-raspberrypi).
        * I am unsure if this is required, but also move `configuration.nix` to `configuration.nix.bak` (or smth; same for `hardware-configuration.nix`)
        * The [nvmd/nixos-raspberrypi](https://github.com/nvmd/nixos-raspberrypi) `README` also gives us the minimal configuration (excluding filesystems):
            * ```nix
              nixosConfigurations.rpi5-demo = nixos-raspberrypi.lib.nixosSystem {
                specialArgs = inputs;
                modules = [
                  {
                    # Hardware specific configuration, see section below for a more complete 
                    # list of modules
                    imports = with nixos-raspberrypi.nixosModules; [
                      raspberry-pi-5.base
                      raspberry-pi-5.display-vc4
                      raspberry-pi-5.bluetooth
                    ];
                  }

                  ({ config, pkgs, lib, ... }: {
                    networking.hostName = "rpi5-demo";

                    system.nixos.tags = let
                      cfg = config.boot.loader.raspberryPi;
                    in [
                      "raspberry-pi-${cfg.variant}"
                      cfg.bootloader
                      config.boot.kernelPackages.kernel.version
                    ];
                  })

                  # ...
                  # (filesystems configuration below goes here)

                ];
              };
              ```
        * Only thing missing from the minimal configuration is the filesystem
          configuration, which you can steal from `hardware-configuration.nix`
          (though I did copy over some extra options from the example flake, not
          sure if these are necessary).
          ```nix
          ({ ... }: {
              fileSystems."/" =
                { device = "/dev/disk/by-label/NIXROOT";
                  fsType = "ext4";
                  options = [ "noatime" ]; 
                };
              fileSystems."/boot/firmware" =
                { device = "/dev/disk/by-label/NIXBOOT";
                  fsType = "vfat";
                  options = [ "<whatever is already in hardware-configuration.nix>" "noatime" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=1m" ]; 
                };
          })
          ```

