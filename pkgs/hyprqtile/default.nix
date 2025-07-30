{
  lib,
  fetchFromGitHub,
  rustPlatform,
  # pkg-config,
  # openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "hyprqtile";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "daniqss";
    repo = "hyprqtile";
    rev = "v${version}";
    hash = "sha256-GGQU+hEnI688El8/GYmIL+HQt6davc6RAU/xuRmSKDw=";
  };

  cargoHash = "sha256-il/VxvE85V23bzGNfj8qUJF7ysAVV8fOO/FX0Akll5M=";

  # nativeBuildInputs = [
  #   pkg-config
  # ];

  # buildInputs = [
  #   openssl
  # ];

  # OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    mainProgram = "hyprqtile";
    homepage = "https://github.com/daniqss/hyprqtile";
    description = ''
      Qtile-like workspaces and monitors management for Hyprland
    '';
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [];
  };
}
