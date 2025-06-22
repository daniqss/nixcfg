{username, ...}: let
in {
  programs.ssh = {
    enable = true;
    compression = true;

    extraConfig = ''
      Host github.com
        User git
        Hostname github.com
        IdentityFile ~/.ssh/github_ed25519
        IdentitiesOnly yes
    '';
  };

  programs.git = {
    enable = true;
    userName = username;
    userEmail = "danielqueijo14@gmail.com";

    extraConfig = {
      core.editor = "nvim";
      push.default = "current";
      push.autoSetupRemote = true;
    };
  };
}
