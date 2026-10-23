{
  inputs,
  outputs,
}: let
  inherit (outputs.lib) mkNixos;
  adminUser = "daniqss";
in {
  # desktop intel+nvidia pc
  stoneward = mkNixos {
    inherit adminUser;
    hostname = "stoneward";
    system = "x86_64-linux";

    modules = [
      inputs.lanzaboote.nixosModules.lanzaboote
    ];
  };

  # amd laptop
  windrunner = mkNixos {
    inherit adminUser;
    hostname = "windrunner";
    system = "x86_64-linux";
    isLaptop = true;

    modules = [];
  };

  # i5 slimbook laptop
  skybreaker = mkNixos {
    inherit adminUser;
    hostname = "skybreaker";
    system = "x86_64-linux";
    isLaptop = true;

    useDisko = true;
    modules = [];
  };

  # mother's laptop
  motherofmachines = mkNixos {
    inherit adminUser;
    users = ["romina"];
    hostname = "motherofmachines";
    system = "x86_64-linux";
    isLaptop = true;

    useDisko = true;
    useProfiles = false;
    modules = [];
  };

  # rpi5 home server
  bondsmith = let
    inherit (inputs) nixos-raspberrypi;
  in
    mkNixos {
      inherit adminUser;
      hostname = "bondsmith";
      system = "aarch64-linux";

      # createSystem = inputs.nixos-raspberrypi.lib.nixosSystem;
      useDisko = true;
      specialArgs = {inherit nixos-raspberrypi;};
      modules = [
        nixos-raspberrypi.lib.inject-overlays
        nixos-raspberrypi.nixosModules.trusted-nix-caches
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
