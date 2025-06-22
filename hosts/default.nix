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
            home-manager.users.${username}.imports = [../home/home.nix];
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

    modules = [];
  };
}
