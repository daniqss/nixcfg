{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.terminal.shell.nushell;

  # direnv is home-manager managed on a foreign distro, and system wide on NixOS
  direnv =
    if config.programs.direnv.enable
    then lib.getExe config.programs.direnv.package
    else "direnv";
in {
  options.terminal.shell.nushell.enable = mkEnableOption "enable nushell as shell";

  config = mkIf cfg.enable {
    programs.nushell = {
      inherit (cfg) enable;

      # on a foreign distro the shell comes from the distro packages
      package =
        if config.platform.isNixOS
        then pkgs.nushell
        else null;

      shellAliases = let
        eza = "${pkgs.eza}/bin/eza --icons auto";
        bat = "${pkgs.bat}/bin/bat";
      in {
        # ls = "${eza}";
        # la = "${eza} -a";
        # ll = "${eza} --header --git -t=mod --time-style=long-iso -l";
        # lla = "${eza} --header --git -t=mod --time-style=long-iso -la";
        # ts = "${eza} --tree --level=2";
        # tsa = "${eza} --tree --level=2 -a";
        # tl = "${eza} --tree --level=2 --header -t=mod --time-style=long-iso -l";
        # tla = "${eza} --tree --level=2 --header -t=mod --time-style=long-iso -la";
        treee = "${eza} --tree";

        grep = "^grep --color=auto";
        cat = "${bat} --paging=never --plain";
        catp = "${bat} --paging=never";
        cls = "clear";

        gitgraph = "^git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'";
      };

      # prompt lives in ./nushell/prompt.nu, as a real nu file so editors can
      # highlight it; nix only injects the store paths it needs
      extraEnv = ''
        $env.NU_GIT_BIN = "${lib.getExe pkgs.git}"

        ${builtins.readFile ./nushell/prompt.nu}
      '';

      # shell config, same split as above
      extraConfig = ''
        $env.NU_CODIUM_BIN = "${lib.getExe' pkgs.vscodium "codium"}"
        $env.NU_DIRENV_BIN = "${direnv}"

        ${builtins.readFile ./nushell/config.nu}

        # ${builtins.readFile ./nushell/direnv.nu}
      '';
    };

    programs.direnv.enableNushellIntegration = true;
    programs.eza.enableNushellIntegration = true;
    programs.lazygit.enableNushellIntegration = true;
    programs.carapace.enableNushellIntegration = true;
  };
}
