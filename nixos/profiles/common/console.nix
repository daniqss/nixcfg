{pkgs, ...}: {
  console = {
    earlySetup = true;
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v28n.psf.gz";
    keyMap = "us";
    useXkbConfig = false;
  };
}
