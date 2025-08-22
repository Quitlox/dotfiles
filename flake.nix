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
    arion.url = "github:hercules-ci/arion";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    sops-nix.url = "github:Mic92/sops-nix";
    srvos.url = "github:nix-community/srvos";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-raspberrypi,
      sops-nix,
      ...
    }@inputs:
    let
      allSystems = nixpkgs.lib.systems.flakeExposed;
      forSystems = systems: f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      nixosConfigurations = {
        quitlox-pi = nixos-raspberrypi.lib.nixosSystemFull {
          specialArgs = inputs;
          modules = [
            ./nixos/hosts/quitlox-pi/configuration.nix
          ];
        };
      };

      formatter = forSystems allSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
