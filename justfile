default: switch

flake := justfile_directory()

platform := if os() == "macos" { "darwin" } else if path_exists("/etc/NIXOS") == "true" { "os" } else { "home" }

switch *ARGS:
    nh {{ platform }} switch {{ flake }} {{ ARGS }}

boot *ARGS:
    nh os boot {{ flake }} {{ ARGS }}

build *ARGS:
    nh {{ platform }} build {{ flake }} {{ ARGS }}

clean:
    nh clean all

update:
    nix flake update --flake {{ flake }}

show:
    nix flake show {{ flake }}

fmt:
    nix fmt {{ flake }}
