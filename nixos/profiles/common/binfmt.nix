{
  lib,
  config,
  ...
}: {
  options.common.binfmt = {
    enable = lib.mkEnableOption "enable binfmt user emulation";
    emulatedSystems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "list of systems to enable binfmt user emulation for";
    };
  };

  config = lib.mkIf config.common.binfmt.enable {
    boot.binfmt.emulatedSystems = config.common.binfmt.emulatedSystems;
  };
}
