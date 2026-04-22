{
  lib,
  config,
  ...
}: {
  options.common.qemu = {
    enable = lib.mkEnableOption "enable qemu user emulation";
    emulatedSystems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "list of systems to enable qemu user emulation for";
    };
  };

  config = lib.mkIf config.common.qemu.enable {
    boot.binfmt.emulatedSystems = config.common.qemu.emulatedSystems;
  };
}
