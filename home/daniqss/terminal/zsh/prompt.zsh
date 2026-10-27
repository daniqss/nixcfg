# zsh port of ../nushell/prompt.nu
#
# PROMPT is rebuilt on every precmd with the dynamic values escaped, instead
# of relying on prompt_subst, so a branch named `%F{red}` or `$(...)` is
# printed as is

zmodload zsh/datetime
autoload -Uz add-zsh-hook add-zle-hook-widget
unsetopt prompt_subst

typeset -g __PROMPT_GIT_BIN=${__PROMPT_GIT_BIN:-git}
typeset -g __PROMPT_GIT_ICON=$''
typeset -gi __PROMPT_DURATION_THRESHOLD=8000
typeset -g __PROMPT_SEPARATOR=" %F{8}|%f "

__prompt_escape() { REPLY=${1//\%/%%}; }

__prompt_git_segment() {
  local out
  out=$("$__PROMPT_GIT_BIN" --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null) || return

  local branch=HEAD line
  local -a ab
  local -i ahead=0 behind=0 stashed=0 staged=0 modified=0 deleted=0 renamed=0 untracked=0 conflicted=0

  for line in "${(@f)out}"; do
    case $line in
      ('# branch.head '*) branch=${line#'# branch.head '} ;;
      ('# branch.ab '*)
        ab=(${=line#'# branch.ab '})
        ahead=${ab[1]#+}
        behind=${ab[2]#-}
        ;;
      ('# stash '*) stashed=${line#'# stash '} ;;
      ('? '*) (( ++untracked )) ;;
      ('u '*) (( ++conflicted )) ;;
      ([12]' '*)
        # columns 3 and 4 hold the staged / unstaged status codes
        case ${line[3]} in
          (R|C) (( ++renamed )) ;;
          (D) (( ++deleted )) ;;
          (.) ;;
          (*) (( ++staged )) ;;
        esac

        case ${line[4]} in
          (D) (( ++deleted )) ;;
          (.) ;;
          (*) (( ++modified )) ;;
        esac
        ;;
    esac
  done

  local tracking=
  if (( ahead > 0 && behind > 0 )); then
    tracking="⇕⇡${ahead}⇣${behind}"
  elif (( ahead > 0 )); then
    tracking="⇡${ahead}"
  elif (( behind > 0 )); then
    tracking="⇣${behind}"
  fi

  local state=
  (( conflicted > 0 )) && state+="=${conflicted}"
  (( stashed > 0 )) && state+="\$${stashed}"
  (( staged > 0 )) && state+="+${staged}"
  (( renamed > 0 )) && state+="»${renamed}"
  (( modified > 0 )) && state+="!${modified}"
  (( deleted > 0 )) && state+="✘${deleted}"
  (( untracked > 0 )) && state+="?${untracked}"

  local flags=${tracking}${tracking:+${state:+ }}${state}

  __prompt_escape "$branch"
  __prompt_segments+="${__PROMPT_SEPARATOR}%B%F{red}${__PROMPT_GIT_ICON} ${REPLY}%f%b"
  [[ -n $flags ]] && __prompt_segments+=" %F{red}${flags}%f"
}

__prompt_nix_segment() {
  [[ -n ${IN_NIX_SHELL-} || -n ${NIX_BUILD_TOP-} ]] || return

  local label=${${name-}%-env}
  if [[ -z $label || $label == nix-shell ]]; then
    label=nix
  else
    label="nix#$label"
  fi

  __prompt_escape "$label"
  __prompt_segments+="${__PROMPT_SEPARATOR}%B%F{cyan}λ ${REPLY}%f%b"
}

__prompt_indicator_line() {
  local -i code=$1 elapsed=0
  local duration= exit_status=

  if (( ${+__prompt_start} )); then
    (( elapsed = (EPOCHREALTIME - __prompt_start) * 1000 ))
  fi

  if (( elapsed >= __PROMPT_DURATION_THRESHOLD )); then
    local pretty
    if (( elapsed < 60000 )); then
      # one decimal, dropped when it is 0 like nushell does
      local -i tenths=$(( (elapsed + 50) / 100 ))
      pretty="$(( tenths / 10 ))"
      (( tenths % 10 )) && pretty+=".$(( tenths % 10 ))"
      pretty+="s"
    else
      local -i secs=$(( elapsed / 1000 ))
      pretty="$(( secs / 60 ))m $(( secs % 60 ))s"
    fi
    duration="%F{yellow}took ${pretty}%f "
  fi

  if (( code != 0 )); then
    exit_status="%B%F{red}[${code}]%f%b "
  fi

  __prompt_indicator="${duration}${exit_status}%B%F{yellow}\$%f%b "
}

__prompt_precmd() {
  # zsh restores $? for every precmd hook, so the position in the list does not matter
  local code=$?

  typeset -g __prompt_segments= __prompt_indicator=
  __prompt_git_segment
  __prompt_nix_segment
  __prompt_indicator_line "$code"
  unset __prompt_start

  PROMPT=$'\n'"%B%F{green}%n@%m%f%b%F{8}:%f%B%F{blue}%~%f%b${__prompt_segments}"$'\n'"${__prompt_indicator}"
}

__prompt_preexec() {
  typeset -gF __prompt_start=$EPOCHREALTIME
}

# collapse the prompt of an accepted line, like nushell's transient prompt
__prompt_transient() {
  PROMPT=$'\n''%B%F{yellow}$%f%b '
  zle .reset-prompt
  zle -R
}

add-zsh-hook precmd __prompt_precmd
add-zsh-hook preexec __prompt_preexec
zle -N __prompt_transient
add-zle-hook-widget line-finish __prompt_transient

RPROMPT=
PS2='%F{8}::: %f'
