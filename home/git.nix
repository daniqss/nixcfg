{...}: let
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
    userName = "daniqss";
    userEmail = "danielqueijo14@gmail.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5cDJjedDVYhu7H3WO2cfuIsn9RKjwXE+1+v3fZpc9X danielqueijo14@gmail.com";
      signByDefault = true;
    };

    extraConfig = {
      core.editor = "nvim";
      gpg.format = "ssh";
      gpg.ssh.program = "ssh";
      push.default = "current";
      push.autoSetupRemote = true;
    };
  };
}
