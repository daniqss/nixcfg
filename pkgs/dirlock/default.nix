{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  pam,
}:
rustPlatform.buildRustPackage rec {
  pname = "dirlock";
  version = "0.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.steamos.cloud";
    owner = "holo";
    repo = "dirlock";
    rev = "b10c930d0f4a5c02a8327d510e1ecb68b1da872f";
    sha256 = "sha256-KAxFi77cgZpjPBYQoe/MylwuOqqbB/AF1Q6AkAjQPek=";
  };

  doCheck = false;
  cargoHash = "sha256-q9AHPjPK0VCDTFD+mdNP2hF5ff4MjpzvdBJsPG/uIfM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pam
  ];

  meta = {
    homepage = "https://gitlab.steamos.cloud/holo/dirlock";
    description = "A tool for managing encrypted directories using the Linux kernel's fscrypt API.";
    longDescription = ''
      `dirlock` is a tool for managing encrypted directories using the Linux
      kernel's fscrypt API. Therefore it encrypts individual directories and
      not complete filesystem or block devices. If a directory is encrypted
      then all its contents (including subdirectories) are encrypted as
      well.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [daniqss];
    platforms = lib.platforms.linux;
    mainProgram = "dirlock";
  };
}
