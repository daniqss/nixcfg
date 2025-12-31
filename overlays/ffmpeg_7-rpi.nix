self: super: {
  ffmpeg_7_rpi = self.callPackage ../pkgs/ffmpeg_7-rpi {
    ffmpeg-rpi-nix = super.ffmpeg_7_rpi.ffmpeg-rpi-nix;
  };
}
