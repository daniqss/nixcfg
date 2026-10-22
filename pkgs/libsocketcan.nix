{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "libsocketcan";
  version = "0-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "linux-can";
    repo = "libsocketcan";
    rev = "8aac4eeacc320b895d5e96bed4b3de63ba301ded";
    hash = "sha256-IWUX0uiqwng5+56Isy68jwKJjIygrOrHFBPtXAoyFIY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/linux-can/libsocketcan";
    description = "Library to control some basic functions in SocketCAN from userspace";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [daniqss];
    platforms = lib.platforms.linux;
  };
}
