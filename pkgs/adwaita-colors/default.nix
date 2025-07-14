{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  findutils,
}:
stdenv.mkDerivation {
  pname = "adwaita-colors";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "dpejoh";
    repo = "Adwaita-colors";
    rev = "2f6b3dc9be1059f99a086c65e3fd12e54aa48c5d";
    sha256 = "sha256-kTgPD9Q8C5+LmwK5Mww4fh3IJ+mYMh400iQU1/u9iR0=";
  };

  nativeBuildInputs = [
    gtk3
    findutils
  ];

  buildInputs = [];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons

    cp -r * $out/share/icons/

    # remove dangling symlinks
    find $out/share/icons -type l ! -exec test -e {} \; -delete

    for theme in $out/share/icons/*/ ; do
      if [ -f "$theme/index.theme" ]; then
        gtk-update-icon-cache -f -t "$theme"
      fi
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      Adwaita Colors customizes Adwaita icons to match your GNOME theme's accent color, providing a cohesive, personalized look.
    '';
    homepage = "https://github.com/dpejoh/Adwaita-colors";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}
