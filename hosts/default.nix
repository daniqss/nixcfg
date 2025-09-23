{
  inputs,
  outputs,
}: let
  lib = inputs.nixpkgs.lib;
  homeModules = inputs.home-manager.nixosModules.home-manager;

  mkSystem = {
    hostname,
    username,
    system,
    createSystem ? lib.nixosSystem, # por defecto usa lib.nixosSystem
    ...
  } @ args:
    createSystem {
      inherit system;

      specialArgs = lib.recursiveUpdate {
        inherit inputs outputs hostname username system;
      } (args.specialArgs or {});

      modules = lib.concatLists [
        [
          {
            networking.hostName = hostname;
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.android_sdk.accept_license = true;
          }
        ]
        (lib.flatten [
          (lib.singleton ./${hostname}/configuration.nix)
          (args.modules or [])
        ])
        [
          homeModules
          {
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = lib.recursiveUpdate {
              inherit inputs outputs hostname username system;
            } (args.specialArgs or {});
            home-manager.users.${username}.imports = [./${hostname}/home.nix];
          }
        ]
      ];
    };
in {
  # desktop intel+nvidia pc
  stoneward = mkSystem {
    hostname = "stoneward";
    username = "daniqss";
    system = "x86_64-linux";

    modules = [
      # inputs.lanzaboote.nixosModules.lanzaboote
    ];
  };

  # amd laptop
  windrunner = mkSystem {
    hostname = "windrunner";
    username = "daniqss";
    system = "x86_64-linux";

    modules = [];
  };

  # rpi5 home server
  bondsmith = mkSystem {
    hostname = "bondsmith";
    username = "daniqss";
    system = "aarch64-linux";

    createSystem = inputs.nixos-raspberrypi.lib.nixosSystem;
    specialArgs = {nixos-raspberrypi = inputs.nixos-raspberrypi;};
    modules = [
      ({...}: {
        imports = with inputs.nixos-raspberrypi.nixosModules; [
          raspberry-pi-5.base
          raspberry-pi-5.bluetooth
        ];
      })
    ];
  };
}
