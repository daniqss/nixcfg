{outputs, ...}: let
  inherit (outputs.lib) mkHome;

  username = "daniel";
  hostname = "dustbringer";
in {
  # ubuntu work laptop, in near future
  "${username}@${hostname}" = mkHome {
    inherit hostname username;
    system = "x86_64-linux";
    isLaptop = true;

    # I cannot change username, so username keeps as IT left it,
    # and I specify the hm dir (nixcfg/home/daniqss)
    hmDir = "daniqss";
  };
}
