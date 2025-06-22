# nixcfg
wip nix configuration for x86_64-linux

# how to
## install
``` bash
sudo nixos-rebuild switch --flake ~/nixcfg/#<wanted-host>
```

## update
``` bash
sudo nix flake update
sudo nixos-rebuild switch --flake ~/nixcfg/#<wanted-host>
```

# special thanks to

- [raexera](https://github.com/raexera/yuki),
- [fufexan](https://github.com/fufexan/dotfiles),
- [redyf](https://github.com/redyf/nixdots)  
- [NotAShelf](https://github.com/NotAShelf/nyx),
