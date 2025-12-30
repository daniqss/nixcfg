{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    valkey = prev.valkey.overrideAttrs (_old: {
      doCheck = false;
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  pinnacle = inputs.pinnacle.overlays.default;
  nix-minecraft = inputs.nix-minecraft.overlays.default;
  ffmpeg_7_rpi = import ./ffmpeg_7-rpi.nix;
}
