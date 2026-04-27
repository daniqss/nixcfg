default: switch

switch *ARGS:
    nh os switch {{ ARGS }}

boot *ARGS:
    nh os boot {{ ARGS }}

clean:
    nh clean --all

update:
    nix flake update

fmt:
    nix fmt
