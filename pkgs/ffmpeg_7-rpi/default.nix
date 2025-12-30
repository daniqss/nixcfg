{
  lib,
  fetchFromGitHub,
  callPackage,
  ffmpeg,
  version ? "7.1.2",
  ffmpegVariant ? "small",
  ffmpeg-rpi-nix,
}: let
  ffmpegVersion = version;
  rpiFfmpegSrc = fetchFromGitHub {
    owner = "jc-kynesim";
    repo = "rpi-ffmpeg";
    rev = "de943d66dab18e89fc10c74459bea1d787edc49d";
    hash = "sha256-Qbgos7uzYXF5E557kR2EXhX9eJRmO0LVmSE2NOpEZY0=";
  };
in
  callPackage ffmpeg-rpi-nix {
    inherit ffmpeg;
    version = ffmpegVersion;
    source = rpiFfmpegSrc;
    inherit ffmpegVariant;
  }
