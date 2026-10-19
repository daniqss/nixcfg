{
  lib,
  config,
  ...
}: let
  cfg = config.terminal.shell;
in {
  # zsh prompt, bash and nushell have their own handmade one
  config = lib.mkIf cfg.zsh.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = false;
      enableNushellIntegration = false;

      settings = {
        add_newline = false;

        format = ''

          $username$hostname[:](bright-black)$directory$git_branch$git_status$nix_shell
          $cmd_duration$status$character'';

        username = {
          style_user = "bold green";
          style_root = "bold green";
          format = "[$user]($style)";
          show_always = true;
        };

        hostname = {
          ssh_only = false;
          style = "bold green";
          format = "[@$hostname]($style)";
        };

        directory = {
          style = "bold blue";
          format = "[$path]($style)";
          truncation_length = 0;
          truncate_to_repo = false;
        };

        git_branch = {
          symbol = " ";
          style = "bold red";
          format = " [|](bright-black) [$symbol$branch]($style)";
        };

        git_status = {
          style = "red";
          format = "([ $ahead_behind]($style))([ $conflicted$staged$renamed$modified$deleted$untracked]($style))";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          conflicted = "=\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
          modified = "!\${count}";
          deleted = "✘\${count}";
          untracked = "?\${count}";
        };

        nix_shell = {
          symbol = "λ nix";
          style = "bold cyan";
          format = " [|](bright-black) [$symbol]($style)";
        };

        cmd_duration = {
          min_time = 8000;
          style = "yellow";
          format = "[took $duration ]($style)";
        };

        status = {
          disabled = false;
          style = "bold red";
          format = "[\\[$status\\] ]($style)";
        };

        character = {
          success_symbol = "[\\$](bold yellow)";
          error_symbol = "[\\$](bold yellow)";
          format = "$symbol ";
        };
      };
    };
  };
}
