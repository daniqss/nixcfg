$env.NU_HOSTNAME = (sys host | get hostname)
$env.NU_USER = ($env.USER? | default (whoami))

const GIT_ICON = ""
const DURATION_THRESHOLD = 8000

def nu-where-segment []: nothing -> string {
  let dir = if $env.PWD == $nu.home-dir {
    "~"
  } else {
    $env.PWD | str replace $"($nu.home-dir)/" "~/"
  }

  [
    $"(ansi green_bold)($env.NU_USER)@($env.NU_HOSTNAME)(ansi reset)"
    $"(ansi dark_gray):(ansi reset)"
    $"(ansi blue_bold)($dir)(ansi reset)"
  ] | str join ""
}

def nu-git-segment []: nothing -> string {
  let res = (^$env.NU_GIT_BIN --no-optional-locks status --porcelain=v2 --branch | complete)
  if $res.exit_code != 0 {
    return ""
  }

  mut branch = "HEAD"
  mut ahead = 0
  mut behind = 0
  mut staged = 0
  mut modified = 0
  mut deleted = 0
  mut renamed = 0
  mut untracked = 0
  mut conflicted = 0

  for line in ($res.stdout | lines) {
    if ($line | str starts-with "# branch.head ") {
      $branch = ($line | str substring 14..)
    } else if ($line | str starts-with "# branch.ab ") {
      let ab = ($line | str substring 12.. | split row " ")
      $ahead = ($ab.0 | into int | math abs)
      $behind = ($ab.1 | into int | math abs)
    } else if ($line | str starts-with "? ") {
      $untracked += 1
    } else if ($line | str starts-with "u ") {
      $conflicted += 1
    } else if (($line | str starts-with "1 ") or ($line | str starts-with "2 ")) {
      # columns 2 and 3 hold the staged / unstaged status codes
      let index = ($line | str substring 2..<3)
      let worktree = ($line | str substring 3..<4)

      if $index in ["R" "C"] {
        $renamed += 1
      } else if $index == "D" {
        $deleted += 1
      } else if $index != "." {
        $staged += 1
      }

      if $worktree == "D" {
        $deleted += 1
      } else if $worktree != "." {
        $modified += 1
      }
    }
  }

  let tracking = if $ahead > 0 and $behind > 0 {
    $"⇕⇡($ahead)⇣($behind)"
  } else if $ahead > 0 {
    $"⇡($ahead)"
  } else if $behind > 0 {
    $"⇣($behind)"
  } else {
    ""
  }

  let state = [
    (if $conflicted > 0 { $"=($conflicted)" } else { "" })
    (if $staged > 0 { $"+($staged)" } else { "" })
    (if $renamed > 0 { $"»($renamed)" } else { "" })
    (if $modified > 0 { $"!($modified)" } else { "" })
    (if $deleted > 0 { $"✘($deleted)" } else { "" })
    (if $untracked > 0 { $"?($untracked)" } else { "" })
  ] | str join ""

  let flags = [$tracking $state] | where {|it| $it != "" } | str join " "

  if ($flags | is-empty) {
    $"(ansi red_bold)($GIT_ICON) ($branch)(ansi reset)"
  } else {
    $"(ansi red_bold)($GIT_ICON) ($branch)(ansi reset) (ansi red)($flags)(ansi reset)"
  }
}

def nu-nix-segment []: nothing -> string {
  if ($env.IN_NIX_SHELL? | is-empty) and ($env.NIX_BUILD_TOP? | is-empty) {
    return ""
  }

  let name = ($env.name? | default "" | str replace --regex '-env$' "")
  let label = if ($name | is-empty) or $name == "nix-shell" { "nix" } else { $"nix:($name)" }

  $"(ansi cyan_bold)λ ($label)(ansi reset)"
}

$env.PROMPT_COMMAND = {||
  let segments = (
    [
      (nu-where-segment)
      (nu-git-segment)
      (nu-nix-segment)
    ]
    | where {|segment| $segment != "" }
    | str join $" (ansi dark_gray)|(ansi reset) "
  )

  $"\n($segments)"
}

$env.PROMPT_COMMAND_RIGHT = ""

$env.PROMPT_INDICATOR = {||
  let code = ($env.LAST_EXIT_CODE? | default 0)
  let elapsed = ($env.CMD_DURATION_MS? | default "0" | into int)

  let duration = if $elapsed >= $DURATION_THRESHOLD {
    let pretty = if $elapsed < 60000 {
      $"(($elapsed / 1000) | math round --precision 1)s"
    } else {
      let secs = ($elapsed // 1000)
      $"(($secs // 60))m (($secs mod 60))s"
    }
    $"(ansi yellow)took ($pretty)(ansi reset) "
  } else {
    ""
  }

  let status = if $code != 0 {
    $"(ansi red_bold)[($code)](ansi reset) "
  } else {
    ""
  }

  $"\n($duration)($status)(ansi yellow_bold)$(ansi reset) "
}

$env.PROMPT_MULTILINE_INDICATOR = $"(ansi dark_gray)::: (ansi reset)"

$env.TRANSIENT_PROMPT_COMMAND = "\n"
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $"(ansi yellow_bold)$(ansi reset) "
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""
