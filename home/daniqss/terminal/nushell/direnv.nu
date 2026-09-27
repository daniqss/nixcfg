use std/config *

def --env direnv-sync []: nothing -> nothing {
  if (which $env.NU_DIRENV_BIN | is-empty) and not ($env.NU_DIRENV_BIN | path exists) {
    return
  }

  let exported = (^$env.NU_DIRENV_BIN export json | from json | default {})

  let unset = ($exported | columns | where {|key| ($exported | get $key) == null })
  for key in $unset {
    hide-env --ignore-errors $key
  }

  $exported
  | reject --optional ...$unset
  | update cells --columns [PATH] {
    do (env-conversions).path.from_string $in
  }
  | load-env
}

$env.config.hooks.env_change.PWD = (
  $env.config.hooks.env_change.PWD?
  | default []
  | append {|| direnv-sync }
)
