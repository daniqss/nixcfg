# create a git worktree of the current repo next to its main checkout
#
# feat/new-feature -> ~/new-feature-nixcfg
# feat/new-feature -> ~/personal/new-feature-nixcfg
#
# if the repo is nixcfg, flakeDir in the new worktree is rewritten to point to it

def main [branch: string, --repo(-r): path, --base(-b): string = "HEAD"] {
  let cwd = $repo | default $env.PWD | path expand
  let common = git -C $cwd rev-parse --path-format=absolute --git-common-dir | complete
  if $common.exit_code != 0 {
    error make {msg: $"($cwd) is not inside a git repository"}
  }

  # main checkout, even when called from inside another worktree
  let main_dir = $common.stdout | str trim | path dirname
  let repo_name = $main_dir | path basename
  let name = $branch | split row "/" | last
  let target_name = $"($name)-($repo_name)"
  let target = $main_dir | path dirname | path join $target_name
  if ($target | path exists) {
    error make {msg: $"($target) already exists"}
  }

  let has_ref = {|ref| (git -C $main_dir show-ref --verify --quiet $ref | complete).exit_code == 0 }
  if (do $has_ref $"refs/heads/($branch)") or (do $has_ref $"refs/remotes/origin/($branch)") {
    # existing local branch, or remote one (git creates the tracking branch)
    git -C $main_dir worktree add $target $branch
  } else {
    git -C $main_dir worktree add -b $branch $target $base
  }

  if $repo_name == "nixcfg" {

    # nixos default:  "/home/${username}/nixcfg"
    # home-manager:   "/home/${username}/personal/nixcfg/"
    let pattern = '(?m)^(.*[Ff]lakeDir.*"[^"]*/)nixcfg(/?";)'
    let changed = (
      git -C $target ls-files "*.nix" | lines
      | each {|file|
        let path = $target | path join $file
        let content = (open --raw $path)
        let replaced = $content | str replace --all --regex $pattern $"${1}($target_name)${2}"
        if $replaced != $content {
          $replaced | save --force --raw $path
          $file
        }
      }
      | compact
    )
    if ($changed | is-not-empty) {
      # hide the changes from git in this worktree only, so they can't be committed
      # (nix still reads the files from disk, so the flake uses the new flakeDir)
      git -C $target update-index --skip-worktree ...$changed
      print $"flakeDir rewritten to ($target_name) in: ($changed | str join ', ')"
      print "  (hidden from git with --skip-worktree, undo with `git update-index --no-skip-worktree <file>`)"
    }
  }

  print $"worktree ready at ($target)"
}
