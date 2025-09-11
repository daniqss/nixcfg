{
  description = "basic android dev template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    android = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    android,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        androidSDK = android.sdk.${system} (sdkPkgs:
          with sdkPkgs; [
            build-tools-34-0-0
            cmdline-tools-latest
            emulator
            platform-tools
            platforms-android-34
            ndk-26-1-10909125
          ]);
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [
              androidSDK
              pkgs.jdk
              pkgs.androidStudioPackages.stable
            ];
            shellHook = ''
              export ANDROID_HOME=${androidSDK}/libexec/android-sdk
              export PATH=$ANDROID_HOME/platform-tools:$PATH
            '';
          };
      }
    );
}
