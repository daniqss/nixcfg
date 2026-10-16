{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  libpulseaudio,
  dbus,
  libGL,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
}: let
  version = "0.13.3";

  sources = {
    x86_64-linux = {
      target = "x86_64-unknown-linux-gnu";
      hash = "sha256-NBIwbkGyyuL3VUv5c+RCz13O8faeTCQEXyMXzoDSSXA=";
    };
    aarch64-linux = {
      target = "aarch64-unknown-linux-gnu";
      hash = "sha256-MrVXRFhHFntW8gPoQojHnsiF5Y7VFnqYdbA9pg19XAQ=";
    };
  };

  pname = "spotifast";
  githubUrl = "https://github.com/crmne/${pname}";

  source =
    sources.${stdenvNoCC.hostPlatform.system}
    or (throw "${pname}: unsupported system ${stdenvNoCC.hostPlatform.system}");

  # winit, glutin and zbus dlopen these by soname, so autoPatchelf misses them and they must stay on LD_LIBRARY_PATH
  runtimeLibs = [
    dbus
    libGL
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
  ];
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname version;

    src = fetchurl {
      url = "${githubUrl}/releases/download/v${finalAttrs.version}/${pname}-v${finalAttrs.version}-${source.target}.tar.gz";
      inherit (source) hash;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      alsa-lib
      libpulseaudio
      stdenv.cc.cc.lib
    ];

    # spotifast-portable.txt is left out on purpose, without it the built-in self-updater stays off
    installPhase = ''
      runHook preInstall

      install -Dm755 ${pname} $out/bin/${pname}
      install -Dm644 packaging/applications/${pname}.desktop $out/share/applications/${pname}.desktop
      install -Dm644 packaging/icons/${pname}.svg $out/share/icons/hicolor/scalable/apps/${pname}.svg

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
    '';

    meta = {
      description = "Fast native Spotify client with local playback and Spotify Connect";
      homepage = "https://spotifast.rocks";
      changelog = "${githubUrl}/releases/tag/v${finalAttrs.version}";

      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [daniqss];
      platforms = lib.attrNames sources;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      mainProgram = pname;
    };
  })
