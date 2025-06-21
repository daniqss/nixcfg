{pkgs, ...}: let
  vscodePackages = with pkgs; [
    nerd-fonts.caskaydia-cove
  ];
in {
  home.packages = vscodePackages;

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions;
      [
        # theming
        pkief.material-icon-theme
        zhuangtongfa.material-theme

        # langs
        jnoortheen.nix-ide
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [];

    profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
  };
}
