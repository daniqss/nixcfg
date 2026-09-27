$env.config.show_banner = false
$env.config.edit_mode = "emacs"
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.case_sensitive = true
$env.config.filesize.unit = "metric"

$env.config.highlight_resolved_externals = true

let plain_shapes = (
  $env.config.color_config
  | columns
  | where {|name| ($name | str starts-with "shape_") }
  | reduce --fold {} {|name, acc| $acc | insert $name "#9399b2" }
)

$env.config.color_config = (
  $env.config.color_config
  | merge $plain_shapes
  | merge {
    hints: { fg: "#585b70" }

    shape_internalcall: { fg: "#a6e3a1" }
    shape_external_resolved: { fg: "#a6e3a1" }
    shape_external: { fg: "#f38ba8" }

    shape_garbage: { fg: "#f38ba8" attr: "b" }
    shape_matching_brackets: { attr: "u" }
  }
)

def --wrapped code [...args] {
  ^$env.NU_CODIUM_BIN ...$args out+err> /dev/null
}

$env.config.keybindings ++= [
  {
    name: backward_kill_word
    modifier: control
    keycode: char_h
    mode: [emacs vi_insert]
    event: { edit: cutwordleft }
  }
  {
    name: accept_autosuggestion
    modifier: alt
    keycode: enter
    mode: [emacs vi_insert]
    event: { send: historyhintcomplete }
  }
]
