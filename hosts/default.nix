{
  inputs,
  outputs,
}: let
  inherit (outputs.lib) mkNixos;
in {
  # desktop intel+nvidia pc
  stoneward = let
    username = "daniqss";
  in
    mkNixos {
      hostname = "stoneward";
      inherit username;
      system = "x86_64-linux";

      modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
      ];
    };

  # amd laptop
  windrunner = mkNixos {
    hostname = "windrunner";
    username = "daniqss";
    system = "x86_64-linux";
    isLaptop = true;

    modules = [];
  };

  # i5 slimbook laptop
  skybreaker = mkNixos {
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
    mkNixos {
      hostname = "bondsmith";
      username = "daniqss";
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
