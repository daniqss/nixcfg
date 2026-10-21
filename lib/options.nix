# option generators for groups of interchangeable programs (shells, terminal emulators...)
# the group picks a default package and each program module declares its own enable,
# which defaults to whether it's the group default
{lib}: let
  inherit (lib) mkOption mkEnableOption types;

  # enum of packages, compared by name so overridden packages are still accepted
  packageEnum = packages: let
    names = map lib.getName packages;
  in
    lib.mkOptionType {
      name = "packageEnum";
      description = "one of ${lib.concatMapStringsSep ", " (n: "pkgs.${n}") names}";
      descriptionClass = "conjunction";
      check = p: lib.isDerivation p && builtins.elem (lib.getName p) names;
      merge = lib.mergeEqualOption;
    };
in {
  inherit packageEnum;

  # `enable` and `default` options of a program group, `packages` being the available programs
  mkProgramGroupOptions = {
    description,
    packages,
    default,
  }: {
    enable = mkEnableOption "the default program of the group";

    default = mkOption {
      type = packageEnum packages;
      inherit default description;
    };
  };

  # enable option of a program inside a group, `group` being its config
  mkProgramEnableOption = group: name:
    mkOption {
      type = types.bool;
      default = group.enable && lib.getName group.default == name;
      defaultText = lib.literalMD "whether `${name}` is the group default";
      description = "Whether to enable ${name}.";
    };

  mkFontOptions = {
    family,
    size,
  }: {
    family = mkOption {
      type = types.str;
      default = family;
      description = "font family";
    };

    size = mkOption {
      type = types.ints.positive;
      default = size;
      description = "font size";
    };
  };
}
