{inputs, ...}: {
  imports = [
    inputs.zlaunch.homeManagerModules.default
  ];

  services.zlaunch.enable = true;
}
