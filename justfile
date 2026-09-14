default: switch

flake := justfile_directory()

switch *ARGS:
    nh os switch {{ flake }} {{ ARGS }}

boot *ARGS:
    nh os boot {{ flake }} {{ ARGS }}

home *ARGS:
    nh home switch {{ flake }} {{ ARGS }}

clean:
    nh clean all

update:
    nix flake update --flake {{ flake }}

show:
    nix flake show {{ flake }}

fmt:
    nix fmt {{ flake }}
