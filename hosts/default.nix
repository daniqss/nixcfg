{
  inputs,
  outputs,
}: let
  lib = inputs.nixpkgs.lib;
  homeModules = inputs.home-manager.nixosModules.home-manager;

  # from https://github.com/raexera/yuki, thanks!!
  mkSystem = {
    hostname,
    username,
    system,
    ...
  } @ args:
    lib.nixosSystem {
      system = system;

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
  # bondsmith = mkSystem {
  #   hostname = "bondsmith";
  #   username = "daniqss";
  #   system = "aarch64-linux";

  #   modules = [
  #     inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
  #     inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
  #   ];
  # };
  bondsmith = inputs.nixos-raspberrypi.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {
      inherit inputs outputs;
      nixos-raspberrypi = inputs.nixos-raspberrypi;
    };
    modules = [
      ({...}: {
        imports = with inputs.nixos-raspberrypi.nixosModules; [
          ./bondsmith/configuration.nix
          raspberry-pi-5.base
          raspberry-pi-5.bluetooth
        ];
      })
    ];
  };
}
