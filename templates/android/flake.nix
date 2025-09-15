{
  description = "basic android dev template, (this doesn't work im using distrobox instead)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = with pkgs; [
              jdk
              androidenv.androidPkgs_9_0.androidsdk
            ];
            shellHook = ''
              export ANDROID_HOME=${androidSDK}/libexec/android-sdk
              export PATH=$ANDROID_HOME/platform-tools:$PATH
            '';
          };
      }
    );
}
