{
  inputs,
  outputs,
}: let
  lib = inputs.nixpkgs.lib;

  # from https://github.com/raexera/yuki, thanks!!
  mkSystem = {
    hostname,
    system,
    ...
  } @ args:
    lib.nixosSystem {
      system = system;

      specialArgs = lib.recursiveUpdate {
        inherit inputs outputs;
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
        (args.sharedModules or [])
      ];
    };

  homeModules = inputs.home-manager.nixosModules.home-manager;
in {
  # desktop intel+nvidia pc
  stoneward = mkSystem {
    hostname = "stoneward";
    system = "x86_64-linux";

    modules = [
      homeModules
      {
        home-manager.useGlobalPkgs = true;
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.daniqss.imports = [../home/home.nix];
      }
    ];
  };
}
