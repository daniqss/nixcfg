{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    valkey = prev.valkey.overrideAttrs (_old: {
      doCheck = false;
    });

    iio-oscilloscope = prev.iio-oscilloscope.overrideAttrs (old: {
      env =
        (old.env or {})
        // {
          NIX_CFLAGS_COMPILE = (old.env.NIX_CFLAGS_COMPILE or "") + " -Wno-error";
        };
    });

    # some icons clip with #SVGID_1_ but never define it, browsers ignore it but qtsvg renders them broken
    # (chromium, google-chrome, flameshot...), removing them falls back to the hicolor icon of the app
    # TODO: report the broken svgs upstream to morewaita and drop this once fixed
    morewaita-icon-theme = prev.morewaita-icon-theme.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          broken=()
          for f in $out/share/icons/MoreWaita/scalable/apps/*.svg; do
            t=$(readlink -f "$f")
            if grep -q 'href="#SVGID_1_"' "$t" && ! grep -q 'id="SVGID_1_"' "$t"; then
              broken+=("$f")
            fi
          done
          rm -f "''${broken[@]}"
        '';
    });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
}
