{outputs}: let
  inherit (outputs.lib) mkHome;

  username = "daniqss";
  edgedancer = "edgedancer";
in {
  # ubuntu work laptop, in near future
  "${username}@${edgedancer}" = mkHome {
    hostname = edgedancer;
    inherit username;
    system = "x86_64-linux";
    isLaptop = true;
  };
}
