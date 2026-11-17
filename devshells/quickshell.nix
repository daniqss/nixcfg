# runs mandra from the repo for hot reload and qmlls, the service comes back on exit
{pkgs}:
pkgs.mkShell {
  buildInputs = [
    pkgs.kdePackages.qtdeclarative
  ];

  # the service sets it for the emoji menu
  QS_EMOJI_DATA = "${pkgs.unicode-emoji}/share/unicode/emoji/emoji-test.txt";

  shellHook = ''
    mandra="$(git rev-parse --show-toplevel)/home/daniqss/graphical/shells/quickshell/mandra"
    # quickshell only writes the qmlls config when this file exists
    [ -e "$mandra/.qmlls.ini" ] || touch "$mandra/.qmlls.ini"

    systemctl --user stop quickshell
    trap 'systemctl --user restart quickshell' EXIT

    qs-dev() { qs -p "$mandra" "$@"; }
    echo "run qs-dev to start mandra from the repo🐉🐉"
  '';
}
