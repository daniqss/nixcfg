{pkgs}: let
  mkMinecraft = import ./mk-minecraft.nix {inherit pkgs;};
in {
  # TODO: this must be refactor
  # maybe flake parts and dendritic pattern could help
  ferreiros = mkMinecraft {
    name = "es herida q duele y no se siente";
    slug = "ferreiros";

    version = "26.3";

    loaderVersion = "0.19.5";

    icon = ../assets/icons/ferreiros.png;

    mods = {
      fabric-api = pkgs.fetchurl {
        name = "fabric-api.jar";
        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/v2j28coa/fabric-api-0.162.0%2B26.3.jar";
        hash = "sha512-WrcJCJUvHSNG0WsSLKMTJ/QFXbWcJ5obw8PFgc41m7VBy6FXMPVbBye+fHxN68SkQSoYPCKODU3qgcc097QSzg==";
      };
      carpet = pkgs.fetchurl {
        name = "carpet.jar";
        url = "https://cdn.modrinth.com/data/TQTTVgYE/versions/yt9oDFOj/fabric-carpet-26.3%2Bv260915.jar";
        hash = "sha512-ekebpp61BJy5Q2XVBEvVjJ+XDFCzSEhh/jZ18ZF/fJnBsfUKXgG92d7ZQNdqmVU5AJo2VuBb4vUT8g7BTemRpw==";
      };
      lithium = pkgs.fetchurl {
        name = "lithium.jar";
        url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/xS0Q8LSi/lithium-fabric-0.26.2%2Bmc26.3.jar";
        hash = "sha512-TX/uZhMu7ccf6rk5C5LJXXBY7b2tD+z6wdg2opULl6fKRjr77eYcfvNhzmXh+Sernond5b8uDgzkhq+1xdvuQA==";
      };
    };

    clientMods = {
      sodium = pkgs.fetchurl {
        name = "sodium.jar";
        url = "https://cdn.modrinth.com/data/AANobbMI/versions/bAZQdGpg/sodium-fabric-0.9.2%2Bmc26.3.jar";
        hash = "sha512-8/Jg8gS4zl6Hd8LHP1N5VnVexh84F7C3i15VaOiqQPFIkfFGR1B1EJdHZlx8iKRcoMqajfPGjXnFjs2qjYxLkw==";
      };
      iris = pkgs.fetchurl {
        name = "iris.jar";
        url = "https://cdn.modrinth.com/data/YL57xq9U/versions/vTN4NRGW/iris-fabric-1.11.7%2Bmc26.3.jar";
        hash = "sha512-2NMxL3f8UqSOSmzYNv2jNmm968tN4LjA0wrcgIsoczClM+C67zVcwc5jNqJoUdl3U2moAqRma3t6YmavIAiPQg==";
      };
      modmenu = pkgs.fetchurl {
        name = "modmenu.jar";
        url = "https://cdn.modrinth.com/data/mOgUt4GM/versions/kyy7dbrZ/modmenu-21.0.0.jar";
        hash = "sha512-WIwMVXlj9HeFcu6Bv6/BkLMywm1ZJsX+fj4WFNz44U9Y47yAqXaUUh3QWQfpdTp8hXUEjqdp5Nv0Cj23Sk4mBg==";
      };
      shulkerboxtooltip = pkgs.fetchurl {
        name = "shulkerboxtooltip.jar";
        url = "https://cdn.modrinth.com/data/2M01OLQq/versions/Cj9VEeGt/shulkerboxtooltip-fabric-5.4.2%2B26.3.jar";
        hash = "sha512-c3IYvaPDX+B1NZXoSYULsDbu/ZUYGlQr29yKt8R3lTCL4Qua7EXKeIB3bBcRGEU20L9Gj+dulMZ02qye1z2IJg==";
      };
    };

    whitelist = {
      ranicocs = "adce2a00-a1de-4904-a8d6-4474668a0a15";
    };

    server.serverProperties.allow-cheats = true;

    server.java.memory = 2048;
    client.java.memory = 8192;
  };
}
