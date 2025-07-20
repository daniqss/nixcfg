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
      "--restore-last-session"
    ];

    extensions = [
      {id = "gpmodmeblccallcadopbcoeoejepgpnb";} # json formatter
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} # react dev tools
      {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # wappalizer
    ];
  };
}
