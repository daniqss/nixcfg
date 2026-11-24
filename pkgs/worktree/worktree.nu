# create a git worktree of the current repo next to its main checkout
#
# feat/new-feature -> ~/new-feature-nixcfg
# feat/new-feature -> ~/personal/new-feature-nixcfg
#
# if the repo is nixcfg, flakeDir in the new worktree is rewritten to point to it

# .git dir shared by all worktrees of the repo that contains `dir`
#   ~/nixcfg/lib -> ~/nixcfg/.git
def git-common-dir [dir: path]: nothing -> string {
  let common = git -C $dir rev-parse --path-format=absolute --git-common-dir | complete
  if $common.exit_code != 0 {
    error make {msg: $"($dir) is not inside a git repository"}
  }
  $common.stdout | str trim
}

# checks out `branch` in `target`, creating it from `base` if it doesn't exist
def add-worktree [
  main_dir: path
  target: path
  branch: string
  base: string
] {
  let has_ref = {|ref| (git -C $main_dir show-ref --verify --quiet $ref | complete).exit_code == 0 }
  if (do $has_ref $"refs/heads/($branch)") or (do $has_ref $"refs/remotes/origin/($branch)") {
    # existing local branch, or remote one (git creates the tracking branch)
    git -C $main_dir worktree add $target $branch
  } else {
    git -C $main_dir worktree add -b $branch $target $base
  }
}

# points flakeDir to the worktree without git seeing the change
def hide-flake-dir [git_dir: path, target: path] {
  # files with a flakeDir path, e.g.
  #   nixos default:  "/home/${username}/nixcfg"
  #   home-manager:   "/home/${username}/personal/nixcfg/"
  let files = (
    git -C $target ls-files "*.nix" | lines
    | where {|file| open --raw ($target | path join $file) | find --regex '[Ff]lakeDir.*"[^"]*/nixcfg/?";' | is-not-empty }
  )
  if ($files | is-empty) { return }

  # git filter that only touches the flakeDir line, the rest of the file behaves as usual:
  #   smudge (checkout):          .../nixcfg             -> .../<worktree dir name>
  #   clean (status, diff, add):  .../<name>-nixcfg      -> .../nixcfg
  # so git never sees the change and it can't be committed, but nix reads the file from disk
  # in the main checkout the dir name is nixcfg, so both are no-ops there
  git -C $target config filter.flakedir.smudge 'sed -E "/[Ff]lakeDir/ s#/nixcfg(/?\";)#/${PWD##*/}\1#"'
  git -C $target config filter.flakedir.clean `sed -E '/[Ff]lakeDir/ s#/[^/"]+-nixcfg(/?";)#/nixcfg\1#'`

  # attributes in .git/info so they aren't committed either
  let attributes = $git_dir | path join info attributes
  mkdir ($attributes | path dirname)
  let existing = if ($attributes | path exists) {
    open --raw $attributes | lines
  } else {
    []
  }
  $files
  | each {|file| $"($file) filter=flakedir" }
  | where {|line| $line not-in $existing }
  | each {|line| $"($line)\n" | save --append --raw $attributes }
  | ignore

  # checkout again so the smudge filter rewrites them
  $files | each {|file| rm ($target | path join $file) } | ignore
  git -C $target checkout -- ...$files

  print $"flakeDir points to ($target | path basename) in: ($files | str join ', ')"
  print "  (hidden from git with the flakedir filter in .git/config and .git/info/attributes)"
}

def main [branch: string, --repo(-r): path, --base(-b): string = "HEAD"] {

  # main checkout, even when called from inside another worktree
  let git_dir = git-common-dir ($repo | default $env.PWD | path expand)
  let main_dir = $git_dir | path dirname
  let repo_name = $main_dir | path basename

  # ~/nixcfg + feat/new-feature -> ~/new-feature-nixcfg
  let name = $branch | split row "/" | last
  let target = $main_dir | path dirname | path join $"($name)-($repo_name)"
  if ($target | path exists) {
    error make {msg: $"($target) already exists"}
  }

  add-worktree $main_dir $target $branch $base

  if $repo_name == "nixcfg" {
    hide-flake-dir $git_dir $target
  }

  print $"worktree ready at ($target)"
}
