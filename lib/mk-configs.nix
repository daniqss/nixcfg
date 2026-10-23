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
    adminUser,
    system,
    users ? [],
    createSystem ? lib.nixosSystem,
    useDisko ? false,
    useProfiles ? true,
    isLaptop ? false,
    hmDir ? adminUser,
    flakeDir ? defaultFlakeDir adminUser,
    ...
  } @ args: let
    specialArgs = mkSpecialArgs {
      inherit hostname system isLaptop flakeDir hmDir;
      username = adminUser;
      isNixOS = true;
      extra = args.specialArgs or {};
    };
  in
    createSystem {
      inherit system specialArgs;

      modules =
        [
          [
            {
              networking.hostName = hostname;
              nixpkgs.hostPlatform = system;
              nixpkgs.config.allowUnfree = true;

              nixpkgs.overlays = outputs.overlays |> builtins.attrValues;
            }
          ]
          (lib.flatten [
            (lib.singleton ../hosts/${hostname}/configuration.nix)
            (lib.singleton ../hosts/${hostname}/hardware-configuration.nix)
            (lib.optionals useProfiles [
              ../nixos/profiles/common
              ../nixos/profiles/desktop
              ../nixos/profiles/server
            ])
            (args.modules or [])
          ])
          [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "bak";
              home-manager.overwriteBackup = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users =
                {
                  ${adminUser}.imports = [
                    ../hosts/${hostname}/home.nix
                    ../home/${hmDir}
                  ];
                }
                // lib.genAttrs users (user: {imports = [../home/${user}];});
            }
          ]
          (lib.flatten [
            (lib.optional useDisko [../hosts/${hostname}/disko.nix])
            (lib.singleton inputs.disko.nixosModules.disko)
          ])
        ]
        |> lib.concatLists;
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
        overlays = outputs.overlays |> builtins.attrValues;
      };

      extraSpecialArgs = mkSpecialArgs {
        inherit hostname username system isLaptop flakeDir hmDir;
        isNixOS = false;
        extra = args.specialArgs or {};
      };

      modules =
        [
          [
            ../hosts/${hostname}/home.nix
            ../home/${hmDir}
          ]
          (args.modules or [])
        ]
        |> lib.concatLists;
    };
in {
  inherit mkNixos mkHome;
}
