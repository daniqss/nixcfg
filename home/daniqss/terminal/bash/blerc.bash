# ble.sh config, mirrors the line editor setup of ../nushell/config.nu

# nushell already reports exit codes and durations in the prompt
bleopt exec_errexit_mark=
bleopt exec_elapsed_mark=
bleopt exec_exit_mark=
bleopt prompt_eol_mark=

# transient prompt, previous commands collapse to a bare `$`
bleopt prompt_ps1_final=$'\n\\[\e[1;33m\\]$\\[\e[0m\\] '

# fuzzy completion, history based suggestions are on by default
bleopt complete_ambiguous=1
bleopt complete_menu_style=align-nowrap
bind 'set completion-ignore-case off'

# every shape in plain gray, then highlight the command word only
__blerc_plain=#9399b2
for __blerc_face in \
  syntax_{default,command,quoted,quotation,escape,expr,varname,delimiter,param_expansion,history_expansion,function_name,comment,glob,brace,tilde,document,document_begin} \
  varname_{array,empty,export,expr,hash,new,number,readonly,transform,unset} \
  filename_{directory,directory_sticky,link,orphan,executable,setuid,setgid,other,socket,pipe,character,block,warning,url,ls_colors} \
  argument_option cmdinfo_cd_cdpath; do
  ble-face -s "$__blerc_face" "fg=$__blerc_plain"
done
unset -v __blerc_plain __blerc_face

ble-face -s command_builtin fg=#a6e3a1
ble-face -s command_builtin_dot fg=#a6e3a1
ble-face -s command_alias fg=#a6e3a1
ble-face -s command_function fg=#a6e3a1
ble-face -s command_file fg=#a6e3a1
ble-face -s command_keyword fg=#a6e3a1
ble-face -s command_jobs fg=#a6e3a1
ble-face -s command_directory fg=#a6e3a1

# unknown commands and syntax errors
ble-face -s syntax_error fg=#f38ba8,bold
ble-face -s argument_error fg=#f38ba8,bold

ble-face -s auto_complete fg=#585b70

ble-bind -f C-h kill-backward-cword
# the auto_complete keymap only exists once the completion module is loaded
blehook/eval-after-load complete '
  ble-bind -m auto_complete -f M-RET auto_complete/insert
  ble-bind -m auto_complete -f M-C-m auto_complete/insert
'
