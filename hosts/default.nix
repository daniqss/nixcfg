{
  inputs,
  outputs,
}: let
  inherit (inputs.nixpkgs) lib;
  homeModules = inputs.home-manager.nixosModules.home-manager;

  mkSystem = {
    hostname,
    username,
    system,
    createSystem ? lib.nixosSystem,
    useDisko ? false,
    isLaptop ? false,
    ...
  } @ args:
    createSystem {
      inherit system;

      specialArgs = lib.recursiveUpdate {
        inherit inputs outputs hostname username system isLaptop;
      } (args.specialArgs or {});

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
          (lib.singleton ./${hostname}/configuration.nix)
          (lib.singleton ./${hostname}/hardware-configuration.nix)
          (lib.singleton ../nixos/profiles/common)
          (lib.singleton ../nixos/profiles/desktop)
          (lib.singleton ../nixos/profiles/server)
          (args.modules or [])
        ])
        [
          homeModules
          ({config, ...}: {
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = lib.recursiveUpdate {
              inherit inputs outputs hostname username system isLaptop;
              nixosConfig = config;
            } (args.specialArgs or {});
            home-manager.sharedModules = [inputs.pinnacle.hmModules.default];
            home-manager.users.${username}.imports = [
              ./${hostname}/home.nix
              ../home/${username}
            ];
          })
        ]
        (lib.flatten [
          (lib.optional useDisko [./${hostname}/disko.nix])
          (lib.singleton inputs.disko.nixosModules.disko)
        ])
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
    isLaptop = true;

    modules = [];
  };

  # i5 slimbook laptop
  skybreaker = mkSystem {
    hostname = "skybreaker";
    username = "daniqss";
    system = "x86_64-linux";
    isLaptop = true;

    useDisko = true;
    modules = [];
  };

  # rpi5 home server
  bondsmith = let
    inherit (inputs) nixos-raspberrypi;
  in
    mkSystem {
      hostname = "bondsmith";
      username = "daniqss";
      system = "aarch64-linux";

      createSystem = inputs.nixos-raspberrypi.lib.nixosSystem;
      useDisko = true;
      specialArgs = {inherit nixos-raspberrypi;};
      modules = [
        {
          imports = [
            nixos-raspberrypi.nixosModules.raspberry-pi-5.base
            # nixos-raspberrypi.nixosModules.raspberry-pi-5.page-size-16k
            nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
            nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
          ];
        }
      ];
    };
}
