{
  inputs,
  outputs,
}: let
  inherit (inputs.nixpkgs) lib;

  mkSpecialArgs = {
    hostname,
    username,
    system,
    isLaptop,
    flakeDir,
    isNixOS,
    hmDir,
    extra ? {},
  }:
    lib.recursiveUpdate {
      inherit inputs outputs hostname username system isLaptop flakeDir isNixOS hmDir;
    }
    extra;

  defaultFlakeDir = username: "/home/${username}/nixcfg";

  # generates a nixos configuration for hosts/default.nix
  mkNixos = {
    hostname,
    username,
    system,
    createSystem ? lib.nixosSystem,
    useDisko ? false,
    isLaptop ? false,
    flakeDir ? defaultFlakeDir username,
    ...
  } @ args: let
    specialArgs = mkSpecialArgs {
      inherit hostname username system isLaptop flakeDir;
      isNixOS = true;
      extra = args.specialArgs or {};
    };
  in
    createSystem {
      inherit system specialArgs;

      modules = lib.concatLists [
        [
          {
            networking.hostName = hostname;
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;

            nixpkgs.overlays = builtins.attrValues outputs.overlays;
          }
        ]
        (lib.flatten [
          (lib.singleton ../hosts/${hostname}/configuration.nix)
          (lib.singleton ../hosts/${hostname}/hardware-configuration.nix)
          (lib.singleton ../nixos/profiles/common)
          (lib.singleton ../nixos/profiles/desktop)
          (lib.singleton ../nixos/profiles/server)
          (args.modules or [])
        ])
        [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username}.imports = [
              ../hosts/${hostname}/home.nix
              ../home/${username}
            ];
          }
        ]
        (lib.flatten [
          (lib.optional useDisko [../hosts/${hostname}/disko.nix])
          (lib.singleton inputs.disko.nixosModules.disko)
        ])
      ];
    };

  # generates a standalone home manager configuration for home/default.nix
  mkHome = {
    hostname,
    username,
    system,
    hmDir ? username,
    isLaptop ? false,
    flakeDir ? defaultFlakeDir username,
    ...
  } @ args:
    inputs.home-manager.lib.homeManagerConfiguration {
      # mkNixos gets these from the nixos module, here we build pkgs ourselves
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = builtins.attrValues outputs.overlays;
      };

      extraSpecialArgs = mkSpecialArgs {
        inherit hostname username system isLaptop flakeDir hmDir;
        isNixOS = false;
        extra = args.specialArgs or {};
      };

      modules = lib.concatLists [
        [
          ../hosts/${hostname}/home.nix
          ../home/${hmDir}
        ]
        (args.modules or [])
      ];
    };
in {
  inherit mkNixos mkHome;
}
