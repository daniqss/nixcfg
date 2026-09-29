{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  dotnetCorePackages,
  fontconfig,
  icu,
  libGL,
  libice,
  libsm,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
}: let
  version = "2.0.0.0";

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-bxWu1CM7Ew+ZheH1DnA8petSN3mjqkUC9/h6jYhPHG4=";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      hash = "sha256-zjBqQGmqzL0YtYim5l8BHVamREiFRQ+KaZ6wcy+jqUA=";
    };
  };

  owner = "topeterk";
  pname = "hitcountermanager";
  upstreamName = "HitCounterManager";

  githubUrl = "https://github.com/${owner}/${upstreamName}";
  rawGithubUrl = "https://raw.githubusercontent.com/${owner}/${upstreamName}";

  source =
    sources.${stdenvNoCC.hostPlatform.system}
    or (throw "${pname}: unsupported system ${stdenvNoCC.hostPlatform.system}");

  # the release tarballs ship no icon, so take it from the sources of the same tag
  icon = fetchurl {
    url = "${rawGithubUrl}/${version}/Source/${upstreamName}/Resources/drawable/FireIcon.png";
    hash = "sha256-Zg/cl2nw6v85V86/gdhafVPAf5sfXbHBLpWNvrbAkCo=";
  };

  # avalonia dlopens these by soname, so autoPatchelf misses them and they must stay on LD_LIBRARY_PATH
  runtimeLibs = [
    dotnet-runtime
    fontconfig
    icu
    libGL
    libice
    libsm
    libx11
    libxcursor
    libxext
    libxi
    libxrandr
  ];
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname version;

    src = fetchurl {
      url = "${githubUrl}/releases/download/${finalAttrs.version}/${upstreamName}-${finalAttrs.version}-${source.platform}.tar.gz";
      inherit (source) hash;
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = runtimeLibs;

    installPhase = ''
      runHook preInstall

      # the bundled apphost is skipped on purpose, the wrapper goes through the dotnet muxer instead
      mkdir -p $out/lib/${pname} $out/share/${pname}
      cp -r *.dll *.so ${upstreamName}.*.json $out/lib/${pname}/

      # seeded into the writable data dir on every start, never writing over user edits
      cp -r Designs HitCounter.html HitCounter.template ${upstreamName}Init.xml $out/share/${pname}/

      install -Dm644 ${icon} $out/share/icons/hicolor/64x64/apps/${pname}.png

      # the app resolves its files relative to the cwd, so it has to run from that data dir
      makeWrapper ${lib.getExe' dotnet-runtime "dotnet"} $out/bin/${pname} \
        --add-flags $out/lib/${pname}/${upstreamName}.dll \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
        --run 'dataDir="''${XDG_DATA_HOME:-$HOME/.local/share}/${upstreamName}"' \
        --run 'mkdir -p "$dataDir"' \
        --run "cp -rn --no-preserve=mode,ownership $out/share/${pname}/. \"\$dataDir\"/ || true" \
        --run 'cd "$dataDir"'

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = pname;
        icon = pname;
        desktopName = upstreamName;
        comment = "Hit and death counter for speedrunning and streaming";
        categories = ["Game" "Utility"];
        keywords = ["hit" "death" "counter" "speedrun" "stream"];
        startupWMClass = upstreamName;
      })
    ];

    meta = {
      description = "Free hit counter / death counter that runs in the background, so you can focus on your game and stream";

      longDescription = ''
        Free Hit Counter that is running in the background, so you can focus on your stream.
        No need to keep any windows open for a window capture any more.
        Initially designed for Dark Souls but supports any game.
        Just add the local HTML file to you broadcasting software and the setup is done.
        Works completely offline, no account or login required.
      '';

      homepage = githubUrl;
      changelog = "${githubUrl}/releases/tag/${finalAttrs.version}";

      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [daniqss];
      platforms = lib.attrNames sources;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode binaryBytecode];
      mainProgram = pname;
    };
  })
