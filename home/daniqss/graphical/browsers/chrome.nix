{
  pkgs,
  lib,
  config,
  ...
}: let
  chrome = pkgs.google-chrome;
in {
  home.packages = lib.mkIf (config.graphical.enable && config.graphical.browsers.media == chrome) [
    chrome
  ];
}
