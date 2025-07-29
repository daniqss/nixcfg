{
  config,
  lib,
  ...
}: {
  programs.chromium = lib.mkIf config.graphical.enable {
    enable = true;
    package = config.graphical.browsers.dev;
    commandLineArgs = [
      "--no-default-browser-check"
      "--hide-crash-restore-bubble"
    ];

    extensions = [
      {id = "gpmodmeblccallcadopbcoeoejepgpnb";} # json formatter
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} # react dev tools
      {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # wappalizer
    ];
  };
}
