_: {
  terminal = {
    enable = true;

    git.identity.email = "daniel.queijo@alen.space";

    ssh.homelab.enable = false;
  };

  dev.enable = true;

  # for now, until more testing
  graphical = {
    enable = false;

    gaming.enable = false;
    personal.enable = false;
  };
}
