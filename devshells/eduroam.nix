{pkgs}:
pkgs.mkShell {
  buildInputs = [
    pkgs.python313
    pkgs.python313Packages.dbus-python
  ];
}
